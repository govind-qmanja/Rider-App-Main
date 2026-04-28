import 'dart:convert';
import 'dart:io';

import 'package:uuid/uuid.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/order_model.dart';
import '../app_constants.dart';
import '../app_state.dart';
import 'queue_service.dart';
// CHANGE: Removed 'import storage_service.dart' — using FirebaseAuth UID directly.

import 'package:permission_handler/permission_handler.dart';
import 'package:disable_battery_optimization/disable_battery_optimization.dart';


/// Handles Firebase Cloud Messaging for receiving orders.
///
/// CHANGE: This is a rider app. FCM delivers new order
///         notifications to the rider (not a store operator).
///
/// Flow:
/// 1. Foreground: Parse & enqueue order -> QueueService shows call notification
/// 2. Background: Persist order only (isolate can't access QueueService)
/// 3. Terminated: Persist order -> on app resume, restore via QueueService
///
/// All notifications go through QueueService.enqueueOrder() to ensure:
/// - Consistent UI handling via CallService
/// - Android doesn't block multiple rapid notifications
class FcmService extends ChangeNotifier with WidgetsBindingObserver {
  FcmService._internal();
  static final FcmService instance = FcmService._internal();
  factory FcmService() => instance;

  bool _initialized = false;

  /// SharedPreferences key for persisting FCM orders across isolates.
  /// Public so QueueService and the background handler can share the same key.
  static const String pendingFcmOrdersKey = 'pending_fcm_orders';
  static const String _lastSentFcmTokenKey = 'last_sent_fcm_token';
  static const String _currentFcmTokenKey = 'current_fcm_token';
  static const String _fcmTokenEndpoint =
      'https://pn280kfz0g.execute-api.ap-south-1.amazonaws.com/send_notification';

  /// Initialize FCM and wire up message handlers.
  /// Gracefully degrades if Firebase is not configured.
  Future<void> initialize([QueueService? qs]) async {
    if (_initialized) return;
    _initialized = true;
    
    WidgetsBinding.instance.addObserver(this);
    
    final queueService = qs ?? QueueService.instance;
    try {
      // Request explicit permissions for reliable background alerts ONLY if logged in
      if (FFAppState().loggedin) {
        await startPermissionsFlow();
      }

      // Request FCM notification permission (standard)
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        debugPrint('[FcmService] Notification permission denied');
      }

      // Ensure foreground notifications display as heads-up (not silently).
      // Without this, FCM data messages in the foreground are invisible.
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // Store initial FCM token and listen for refreshes.
      // On iOS, this will only succeed AFTER the APNs token is available.
      try {
        final initialToken = await FirebaseMessaging.instance.getToken();
        if (initialToken != null && initialToken.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_currentFcmTokenKey, initialToken);
          debugPrint('[FcmService] Initial FCM token stored: ${initialToken.substring(0, 10)}...');
        }
      } catch (e) {
        debugPrint('[FcmService] Failed to get initial token (may succeed later via Home page): $e');
      }

      // Listen for token refreshes — critical for iOS where tokens rotate more often.
      // When the token changes, save locally and sync to backend immediately.
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
        debugPrint('[FcmService] FCM token refreshed: ${newToken.substring(0, 10)}...');
        try {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_currentFcmTokenKey, newToken);
          await _sendTokenToBackend(newToken);
        } catch (e) {
          debugPrint('[FcmService] Failed to handle token refresh: $e');
        }
      });

      // Foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('[FcmService] Foreground message: ${message.messageId}');
        _handleMessage(message, queueService);
      });

      // Background/terminated -> tapped notification opens app
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint('[FcmService] Message opened app: ${message.messageId}');
        // State-driven navigation will show correct screen
      });

      // Check for initial message (app launched from terminated via notification).
      // Use _handleRestoredMessage (showCallKit: false) because if the app was
      // launched via a notification tap, CallKit was already shown by the
      // background handler. Showing it again causes a duplicate call screen.
      final initialMessage = await FirebaseMessaging.instance
          .getInitialMessage();
      if (initialMessage != null) {
        debugPrint('[FcmService] Initial message: ${initialMessage.messageId}');
        _handleRestoredMessage(initialMessage, queueService);
      }

      // Restore any orders persisted by background handler
      await _restorePendingFcmOrders(queueService);

      debugPrint('[FcmService] Initialized successfully');
    } catch (e) {
      debugPrint('[FcmService] Initialization failed: $e');
      // Graceful degradation - app works without FCM
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && FFAppState().loggedin) {
      // When user returns from Settings, check next permission
      if (Platform.isAndroid) {
        Future.delayed(const Duration(milliseconds: 500), () {
           _requestNextMissingPermission();
        });
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Public method to trigger the staggered permission flow.
  /// Can be called after login to start the setup process.
  Future<void> startPermissionsFlow() async {
    if (!FFAppState().loggedin) return;
    await _requestCriticalPermissions();
  }

  /// Request system permissions required for full-screen alerts and background work.
  ///
  /// IMPORTANT: Each "request" for battery, overlay, exact alarm, or full-screen
  /// intent opens an Android Settings screen (startActivity). If we open multiple
  /// settings screens back-to-back, the app keeps bouncing to the background and
  /// appears "stuck". To prevent this:
  ///   1. We only open ONE settings screen per app launch.
  ///   2. We wait 3 seconds so the Home page renders first.
  ///   3. We remember which permissions were already prompted (SharedPreferences).
  Future<void> _requestCriticalPermissions() async {
    debugPrint('[FcmService] Requesting critical permissions...');
    
    // 1. Notification Permission (Standard dialog — does NOT leave the app)
    if (!await Permission.notification.isGranted) {
      debugPrint('[FcmService] Requesting notification permission');
      await Permission.notification.request();
    }

    if (Platform.isAndroid) {
      // Begin the sequential permission flow after UI settles
      Future.delayed(const Duration(seconds: 3), () async {
        await _requestNextMissingPermission();
      });
    }
  }

  /// Checks permissions in priority order and requests only the FIRST one
  /// that is missing. Only prompts once per permission (tracked via prefs).
  Future<void> _requestNextMissingPermission() async {
    const batteryChannel = MethodChannel('com.qmanja.foods.riders/battery');
    final prefs = await SharedPreferences.getInstance();

    // Helper to avoid re-prompting for a permission we already asked about.
    bool alreadyPrompted(String key) => prefs.getBool('perm_prompted_$key') ?? false;
    Future<void> markPrompted(String key) => prefs.setBool('perm_prompted_$key', true);

    try {
      // Priority 1: Battery Optimization (most critical for background FCM)
      final bool isIgnoring = await batteryChannel.invokeMethod('isIgnoringBatteryOptimizations') ?? true;
      if (!isIgnoring && !alreadyPrompted('battery')) {
        debugPrint('[FcmService] Requesting Battery Optimization via native');
        await markPrompted('battery');
        await batteryChannel.invokeMethod('requestBatteryOptimization');
        return; // Stop here — only one prompt per launch
      }

      // Priority 2: Overlay (Display over other apps)
      final bool canDraw = await batteryChannel.invokeMethod('canDrawOverlays') ?? true;
      if (!canDraw && !alreadyPrompted('overlay')) {
        debugPrint('[FcmService] Requesting Overlay Permission via native');
        await markPrompted('overlay');
        await batteryChannel.invokeMethod('requestOverlayPermission');
        return;
      }

      // Priority 3: Exact Alarm (Android 12+)
      final bool canSchedule = await batteryChannel.invokeMethod('canScheduleExactAlarms') ?? true;
      if (!canSchedule && !alreadyPrompted('exact_alarm')) {
        debugPrint('[FcmService] Requesting Exact Alarm via native');
        await markPrompted('exact_alarm');
        await batteryChannel.invokeMethod('requestExactAlarmPermission');
        return;
      }

      // Priority 4: Full Screen Intent (Android 14+)
      final bool canFullScreen = await batteryChannel.invokeMethod('canUseFullScreenIntent') ?? true;
      if (!canFullScreen && !alreadyPrompted('full_screen_intent')) {
        debugPrint('[FcmService] Requesting Full Screen Intent permission via native');
        await markPrompted('full_screen_intent');
        await batteryChannel.invokeMethod('requestFullScreenIntentPermission');
        return;
      }

      debugPrint('[FcmService] All critical permissions are granted ✅');
    } catch (e) {
      debugPrint('[FcmService] Error checking/requesting permissions: $e');
    }
  }

  /// Parse message and enqueue order.
  static void _handleMessage(RemoteMessage message, QueueService queueService) {
    try {
      // Do not process foreground notifications if user is logged out
      if (!FFAppState().loggedin) {
        debugPrint('[FcmService] Ignoring foreground message — user is logged out');
        return;
      }

      final data = message.data;

      // Actual FCM payload from backend:
      // {
      //   "type": "order",
      //   "order_id": "<firestore doc id>",
      //   "price": "<subtotal>",
      //   "restaurant": "New Order"
      // }

      if (data.isEmpty) {
        debugPrint('[FcmService] Empty message data');
        return;
      }

      final now = DateTime.now();
      final order = OrderModel(
        id: data['order_id'] ?? 'ORD-${now.millisecondsSinceEpoch}',
        orderType:'',
        restaurantName: data['restaurant'] ?? 'New Order',
        customerName: '',
        subtitle: '',
        status: 'pending',
        items: [],
        totalAmount: double.tryParse(data['price'] ?? '0') ?? 0.0,
        createdAt: now,
        receivedAt: now,
      );

      // On Android, the native OrderFirebaseMessagingService unconditionally shows a notification.
      // We must NOT show CallKit here, otherwise we get duplicate notifications/call screens.
      // On iOS, we still relying on CallKit.
      final bool showCallKit = !Platform.isAndroid;

      queueService.enqueueOrder(order, showCallKit: showCallKit);
      if (Platform.isAndroid) {
        debugPrint('[FcmService] Order enqueued from FCM (native notification handled by OrderFirebaseMessagingService): ${order.id}');
      } else {
        debugPrint('[FcmService] Order enqueued from FCM: ${order.id}');
      }
    } catch (e) {
      debugPrint('[FcmService] Failed to parse message: $e');
    }
  }

  /// Handle a message that was received while app was terminated/background.
  /// Unlike _handleMessage, this does NOT show CallKit because the background
  /// handler already showed it. Only enqueues silently into QueueService.
  static void _handleRestoredMessage(
    RemoteMessage message,
    QueueService queueService,
  ) {
    try {
      if (!FFAppState().loggedin) {
        debugPrint('[FcmService] Ignoring restored message — user is logged out');
        return;
      }
      
      final data = message.data;
      if (data.isEmpty) return;

      final now = DateTime.now();
      final order = OrderModel(
        id: data['order_id'] ?? 'ORD-${now.millisecondsSinceEpoch}',
        orderType: 'Delivery',
        restaurantName: data['restaurant'] ?? 'New Order',
        customerName: '',
        subtitle: '',
        status: 'pending',
        items: [],
        totalAmount: double.tryParse(data['price'] ?? '0') ?? 0.0,
        createdAt: now,
        receivedAt: now,
      );

      // showCallKit: false — background handler already showed it
      queueService.enqueueOrder(order, showCallKit: false);
      debugPrint('[FcmService] Restored order enqueued (no CallKit): ${order.id}');
    } catch (e) {
      debugPrint('[FcmService] Failed to parse restored message: $e');
    }
  }

  /// Restore orders that were persisted by the background handler.
  ///
  /// IMPORTANT: Uses showCallKit: false because the background handler
  /// already showed CallKit on the lock screen. Showing it again here
  /// would cause a duplicate notification (the bug where accepting an
  /// order on the lock screen triggers a second call screen).
  static Future<void> _restorePendingFcmOrders(
    QueueService queueService,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Reload to get latest data (background isolate may have written)
      await prefs.reload();
      final ordersJson = prefs.getStringList(pendingFcmOrdersKey) ?? [];

      if (ordersJson.isEmpty) return;

      // Clear FIRST to prevent any race condition where another restore
      // could read the same orders before we finish processing.
      await prefs.remove(pendingFcmOrdersKey);

      for (final json in ordersJson) {
        try {
          final map = jsonDecode(json) as Map<String, dynamic>;
          final order = OrderModel.fromMap(map);
          if (!order.isExpired) {
            // showCallKit: false — background handler already showed it.
            // This only adds the order to QueueService's in-memory state.
            queueService.enqueueOrder(order, showCallKit: false);
          }
        } catch (e) {
          debugPrint('[FcmService] Failed to restore FCM order: $e');
        }
      }
    } catch (e) {
      debugPrint('[FcmService] Failed to restore FCM orders: $e');
    }
  }

  static Future<void> _sendTokenToBackend(String token) async {
    if (token.isEmpty) return;
    if (_fcmTokenEndpoint.isEmpty) {
      debugPrint('[FcmService] FCM token endpoint not configured');
      return;
    }

    final uri = Uri.tryParse(_fcmTokenEndpoint);
    if (uri == null) {
      debugPrint('[FcmService] Invalid FCM token endpoint');
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final lastSent = prefs.getString(_lastSentFcmTokenKey);
      if (lastSent == token) return;

      final operatorId = FFAppState().RiderID.toString();

      final payload = jsonEncode({
        'DeviceToken': token,
        'DropAddress': '',
        'EstimatedPay': '',
        // CHANGE: MerchantName maps to the rider ID
        'MerchantName': operatorId,
        'Distance': '',
        'Platform': Platform.operatingSystem,
      });

      final client = HttpClient();
      try {
        final request = await client.postUrl(uri);
        request.headers.contentType = ContentType.json;
        request.add(utf8.encode(payload));
        final response = await request.close();

        final body = await response.transform(utf8.decoder).join();

        if (response.statusCode >= 200 && response.statusCode < 300) {
          await prefs.setString(_lastSentFcmTokenKey, token);
          debugPrint('[FcmService] FCM token synced');
          debugPrint('[FcmService] Backend response: $body');
        } else {
          debugPrint(
            '[FcmService] FCM token sync failed: ${response.statusCode} - $body',
          );
        }
      } finally {
        client.close(force: true);
      }
    } catch (e, st) {
      debugPrint('[FcmService] FCM token sync error: $e');
      debugPrint(st.toString());
    }
  }

  /// Public helper to force syncing the currently stored token to backend and Firestore.
  static Future<void> syncCurrentToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_currentFcmTokenKey) ?? '';
      if (token.isEmpty) {
        debugPrint('[FcmService] No FCM token available to sync');
        return;
      }
      await _sendTokenToBackend(token);
    } catch (e, st) {
      debugPrint('[FcmService] syncCurrentToken error: $e');
      debugPrint(st.toString());
    }
  }

  

  // ===========================================================================
  // Battery Optimization Whitelisting (via disable_battery_optimization)
  // ===========================================================================

  /// Checks if battery optimization is already ignored; if not, requests
  /// the exemption via the disable_battery_optimization package.
  ///
  /// Handles both native Android battery optimization AND OEM-specific
  /// optimizations (Xiaomi, Samsung, Oppo, Huawei, OnePlus, etc.).
  ///
  /// Returns `true` if the app is whitelisted after the request, `false`
  /// otherwise (user declined or error occurred).
  static Future<bool> requestBatteryOptimization() async {
    if (!Platform.isAndroid) return true; // Not applicable on iOS

    try {
      // 1. Check if native battery optimization is already disabled
      final bool isBatteryOptDisabled =
          await DisableBatteryOptimization.isBatteryOptimizationDisabled ?? false;

      if (isBatteryOptDisabled) {
        debugPrint('[FcmService] Battery optimization already disabled');
      } else {
        debugPrint('[FcmService] Battery optimization NOT disabled — requesting exemption.');
        await DisableBatteryOptimization.showDisableBatteryOptimizationSettings();
      }

      // 2. Check & handle manufacturer-specific optimizations (Xiaomi, Samsung, etc.)
      final bool isManufacturerOptDisabled =
          await DisableBatteryOptimization.isManufacturerBatteryOptimizationDisabled ?? false;

      if (!isManufacturerOptDisabled) {
        debugPrint('[FcmService] Manufacturer battery optimization detected — showing steps.');
        await DisableBatteryOptimization.showDisableManufacturerBatteryOptimizationSettings(
          'Additional battery optimization detected',
          'Follow the steps to disable battery optimization for reliable order notifications.',
        );
      }

      // 3. Check & handle auto-start permission
      final bool isAutoStartEnabled =
          await DisableBatteryOptimization.isAutoStartEnabled ?? false;

      if (!isAutoStartEnabled) {
        debugPrint('[FcmService] Auto-start not enabled — showing steps.');
        await DisableBatteryOptimization.showEnableAutoStartSettings(
          'Enable Auto Start',
          'Allow this app to auto-start so you never miss an order notification.',
        );
      }

      // 4. Final check
      final bool allDisabled =
          await DisableBatteryOptimization.isAllBatteryOptimizationDisabled ?? false;

      debugPrint(
        '[FcmService] Battery whitelist result: '
        '${allDisabled ? "ALL OPTIMIZATIONS DISABLED" : "Some optimizations may still be active"}',
      );

      return allDisabled;
    } catch (e) {
      debugPrint('[FcmService] Battery optimization request failed: $e');
      return false;
    }
  }

  /// Onboarding step: ensures the app is exempt from battery optimization.
  ///
  /// Call this during the onboarding / first-launch flow.
  /// - If already whitelisted → returns `true` immediately (continue onboarding).
  /// - If not → calls [requestBatteryOptimization] which guides the user
  ///   through the exemption dialog/settings.
  ///
  /// Returns `true` if the app is whitelisted after the step completes.
  static Future<bool> onboardingStepBatteryOptimization() async {
    if (!Platform.isAndroid) return true; // Nothing to do on iOS

    debugPrint('[FcmService] Onboarding: checking battery optimization...');

    try {
      final bool allDisabled =
          await DisableBatteryOptimization.isAllBatteryOptimizationDisabled ?? false;

      if (allDisabled) {
        debugPrint(
          '[FcmService] Onboarding: all battery optimizations already disabled — continuing',
        );
        return true;
      }
    } catch (e) {
      debugPrint('[FcmService] Onboarding: error checking battery optimization: $e');
      return true; // Don't block onboarding on error
    }

    // Not whitelisted — request the exemption
    debugPrint(
      '[FcmService] Onboarding: battery optimization is active — requesting exemption',
    );
    final result = await requestBatteryOptimization();

    debugPrint(
      '[FcmService] Onboarding: battery optimization step complete — '
      '${result ? "whitelisted ✓" : "not whitelisted ✗"}',
    );
    return result;
  }
}

/// Top-level background message handler.
/// Must be a top-level function (not a class method).
/// Runs in a separate isolate - cannot access QueueService.
/// Shows lock screen CallKit notification immediately and persists the order.
/// When app resumes, QueueService restores the persisted order and handles navigation.
///
/// Firebase holds a partial wake lock during this handler's execution.
/// We must complete all work (persist + show notification) before returning,
/// otherwise the CPU may sleep and the notification won't display.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('[FcmService] Background message: ${message.messageId}');

  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    final bool isLoggedIn = prefs.getBool('ff_loggedin') ?? false;
    
    // Do not show notification or process if user is logged out
    if (!isLoggedIn) {
      debugPrint('[FcmService] Ignoring background message — user is logged out');
      return;
    }

    final data = message.data;
    if (data.isEmpty) return;

    final now = DateTime.now();
    // Items not sent in payload, default to empty list for persistence
    final items = <Map<String, dynamic>>[];
    const subtitle = '';

    // Build order map for persistence
    final orderMap = <String, dynamic>{
      'id': data['order_id'] ?? 'ORD-${now.millisecondsSinceEpoch}',
      'orderType': 'Delivery',
      'restaurantName': data['restaurant'] ?? 'New Order',
      'customerName': '',
      'subtitle': subtitle,
      'status': 'pending',
      'items': items,
      'totalAmount': double.tryParse(data['price'] ?? '0') ?? 0.0,
      'createdAt': now.toIso8601String(),
      'receivedAt': now.toIso8601String(),
      'timeoutSeconds': 45,
    };

    // On Android: The native OrderFirebaseMessagingService already shows
    // the custom notification before the Dart handler runs. We only need
    // to persist the order here for state restoration.
    //
    // On iOS: We need to both persist and show CallKit notification.
    if (Platform.isAndroid) {
      await _persistOrderInBackground(orderMap);
    } else {
      await Future.wait([
        _persistOrderInBackground(orderMap),
        _showNotificationForBackground(orderMap),
      ]);
    }

    debugPrint(
      '[FcmService] Background order persisted & notification shown: ${orderMap['id']}',
    );
  } catch (e, st) {
    debugPrint('[FcmService] Background handler error: $e');
    debugPrint(st.toString());
  }
}

/// Persist order to SharedPreferences in background isolate.
/// 
/// Separated from main handler so it can run in parallel with notification display.
Future<void> _persistOrderInBackground(Map<String, dynamic> orderMap) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    // Reload to pick up any changes from main isolate
    await prefs.reload();
    final existing = prefs.getStringList(FcmService.pendingFcmOrdersKey) ?? [];
    existing.add(jsonEncode(orderMap));
    await prefs.setStringList(FcmService.pendingFcmOrdersKey, existing);
  } catch (e) {
    debugPrint('[FcmService] Failed to persist order in background: $e');
  }
}

/// Parse items JSON string to list of maps (used in background handler)


/// Show notification in background handler (isolated context).
///
/// Android: Uses the native OrderNotificationHelper via MethodChannel
///          to show custom notification with "Accept" / "Reject" buttons.
/// iOS:     Uses CallKit for native incoming call UI.
///
/// The background isolate creates a temporary MethodChannel on the background
/// engine. This works because firebase_messaging sets up a background
/// FlutterEngine for background message handling.
Future<void> _showNotificationForBackground(
  Map<String, dynamic> orderMap,
) async {
  try {
    if (Platform.isAndroid) {
      await _showNativeNotificationInBackground(orderMap);
    } else {
      await _showCallKitNotificationForBackground(orderMap);
    }
  } catch (e) {
    debugPrint('[FcmService] Failed to show notification in background: $e');
  }
}

/// Show native Android notification from background isolate.
Future<void> _showNativeNotificationInBackground(
  Map<String, dynamic> orderMap,
) async {
  try {
    const channel = MethodChannel('com.qmanja.foods.riders/order_notification');

    final totalAmount = (orderMap['totalAmount'] as num?)?.toDouble() ?? 0.0;
    final amountText = '\u20B9${totalAmount.toStringAsFixed(2)}';
    final orderDetails = 'Order #${orderMap['id']}';

    await channel.invokeMethod('showOrderNotification', {
      'orderId': orderMap['id'] as String,
      'restaurantName': orderMap['restaurantName'] as String,
      'orderDetails': orderDetails,
      'amountText': amountText,
      'orderDataJson': jsonEncode(orderMap),
    });

    debugPrint(
      '[FcmService] Native notification shown for: ${orderMap['id']}',
    );
  } catch (e) {
    debugPrint('[FcmService] Native notification failed, falling back to CallKit: $e');
    // Fallback to CallKit if native notification fails
    await _showCallKitNotificationForBackground(orderMap);
  }
}

/// Fallback: Show CallKit notification (used on iOS and as Android fallback).
///
/// IMPORTANT: This runs in a background isolate where most app state is
/// unavailable. All values must be safe for the Swift CallKit plugin, which
/// force-unwraps certain fields. We sanitize the `extra` map to only contain
/// String values to prevent "Unexpectedly found nil" crashes.
Future<void> _showCallKitNotificationForBackground(
  Map<String, dynamic> orderMap,
) async {
  try {
    // Sanitize values — use null-safe access with fallbacks.
    // The Swift plugin force-unwraps these, so null = crash.
    final String callId = (orderMap['id'] as String?) ?? 'ORD-${DateTime.now().millisecondsSinceEpoch}';
    final String callerName = (orderMap['restaurantName'] as String?) ?? 'New Order';
    final num totalAmount = (orderMap['totalAmount'] as num?) ?? 0.0;
    final int timeoutSeconds = (orderMap['timeoutSeconds'] as int?) ?? 45;

    // CRITICAL: The Swift plugin crashes if `extra` contains non-String values
    // (Lists, Maps, nested objects). Sanitize to String-only map.
    final Map<String, String> sanitizedExtra = {};
    orderMap.forEach((key, value) {
      if (value != null) {
        sanitizedExtra[key] = value.toString();
      }
    });

    final String callUuid = const Uuid().v5(Uuid.NAMESPACE_URL, 'qmanja://order/$callId');

    final params = CallKitParams(
      id: callUuid,
      nameCaller: callerName,
      // Hardcoded — FFAppConstants may not be accessible in background isolate
      appName: 'Qmanja Rider',
      avatar: null,
      handle: 'Amount: \u20B9${totalAmount.toStringAsFixed(2)}',
      type: 0,
      duration: timeoutSeconds * 1000,
      textAccept: 'Accept',
      textDecline: 'Reject',
      missedCallNotification: null,
      extra: sanitizedExtra,
      android: const AndroidParams(
        isCustomNotification: true,
        isShowLogo: true,
        isShowFullLockedScreen: true,
        ringtonePath: 'system_ringtone_default',
        backgroundColor: '#1A237E',
        backgroundUrl: null,
        actionColor: '#4CAF50',
        textColor: '#FFFFFF',
        incomingCallNotificationChannelName: 'Incoming Orders',
        missedCallNotificationChannelName: 'Missed Orders',
        isShowCallID: false,
      ),
      ios: const IOSParams(
        handleType: 'generic',
        supportsVideo: false,
        maximumCallGroups: 1,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'default',
        audioSessionActive: false,
      ),
    );

    // IMPORTANT: On cold launch from a push notification, the background handler
    // fires within milliseconds. The CallKit plugin's Swift singleton (CXProvider,
    // CXCallController) may not be fully initialized yet, causing a nil access
    // crash at SwiftFlutterCallkitIncomingPlugin.swift:286. 
    // We use a valid UUID for the call ID as required by iOS CallKit and 
    // increase the delay to 1000ms to ensure the native side is ready.
    await Future.delayed(const Duration(milliseconds: 1000));
    await FlutterCallkitIncoming.showCallkitIncoming(params);
    debugPrint(
      '[FcmService] CallKit notification shown for: $callId',
    );
  } catch (e) {
    debugPrint('[FcmService] ❌ CallKit showCallkitIncoming crashed: $e');
    // Do NOT rethrow — a crash in background kills the entire app process
  }
}