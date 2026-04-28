import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/random_data_util.dart' as random_data;

import '../models/order_model.dart';
import '../app_constants.dart';

/// Handles incoming order notifications for both Android and iOS.
/// 
/// Updated to use UpdateRiderCall API for order acceptance, replacing legacy Firestore logic.
class CallService {
  CallService._internal();
  static final CallService instance = CallService._internal();
  factory CallService() => instance;

  bool _initialized = false;

  // Platform channels for Android native notification
  static const MethodChannel _notificationChannel =
      MethodChannel('com.qmanja.foods.riders/order_notification');
  static const EventChannel _eventChannel =
      EventChannel('com.qmanja.foods.riders/order_events');

  // iOS CallKit event subscription
  StreamSubscription<CallEvent?>? _callKitSubscription;

  // Android native event subscription
  StreamSubscription<dynamic>? _nativeEventSubscription;

  // Event streams for QueueService to listen to
  final StreamController<OrderModel> _onAcceptController =
      StreamController<OrderModel>.broadcast();
  final StreamController<String> _onDeclineController =
      StreamController<String>.broadcast();

  /// Stream of accepted orders (with full OrderModel from extra payload).
  Stream<OrderModel> get onAccept => _onAcceptController.stream;

  /// Stream of declined order IDs.
  Stream<String> get onDecline => _onDeclineController.stream;

  /// Initialize event listeners. Call once from main().
  void initialize() {
    if (_initialized) return;
    _initialized = true;

    if (Platform.isAndroid) {
      _initializeAndroid();
    } else {
      _initializeIos();
    }

    debugPrint('[CallService] Initialized (${Platform.operatingSystem})');
  }

  // ============================================================
  // Android: Native Custom Notification
  // ============================================================

  void _initializeAndroid() {
    // Listen for accept/reject events from native BroadcastReceivers
    _nativeEventSubscription = _eventChannel
        .receiveBroadcastStream()
        .listen(
          _onNativeEvent,
          onError: (e) => debugPrint('[CallService] Native event error: $e'),
        );
  }

  void _onNativeEvent(dynamic event) {
    if (event is! Map) return;

    final eventType = event['event'] as String?;
    final orderId = event['orderId'] as String?;

    debugPrint('[CallService] Native event: $eventType for $orderId');

    switch (eventType) {
      case 'accept':
        _handleNativeAccept(orderId, event['orderData'] as String?);
        break;
      case 'reject':
        _handleNativeReject(orderId);
        break;
    }
  }

  Future<void> _handleNativeAccept(String? orderId, String? orderDataJson) async {
    if (orderId == null) return;

    // Dismiss notification immediately
    _dismissNativeNotification(orderId);

    // ── PRE-CHECK: Accept order via API ──
    final success = await _acceptOrderViaApi(orderId);
    if (!success) {
      debugPrint('[CallService] Failed to accept order $orderId via API. Ignoring.');
      return;
    }

    if (orderDataJson != null && orderDataJson.isNotEmpty) {
      try {
        final map = jsonDecode(orderDataJson) as Map<String, dynamic>;
        final order = OrderModel.fromMap(map);
        _onAcceptController.add(order);
        debugPrint('[CallService] Order accepted (native): ${order.id}');
        return;
      } catch (e) {
        debugPrint('[CallService] Failed to parse accept data: $e');
      }
    }

    // Fallback: emit a minimal OrderModel with just the orderId
    debugPrint('[CallService] Accept with orderId only (fallback): $orderId');
    final fallbackOrder = OrderModel.fromMap({'id': orderId});
    _onAcceptController.add(fallbackOrder);
  }

  void _handleNativeReject(String? orderId) {
    if (orderId == null) return;

    _dismissNativeNotification(orderId);
    _onDeclineController.add(orderId);
    debugPrint('[CallService] Order rejected (native): $orderId');
  }

  // ============================================================
  // iOS: CallKit
  // ============================================================

  void _initializeIos() {
    _callKitSubscription = FlutterCallkitIncoming.onEvent.listen(
      _onCallKitEvent,
      onError: (e, s) => debugPrint('[CallService] CallKit error: $e'),
    );
  }

  void _onCallKitEvent(CallEvent? event) {
    if (event == null) return;

    debugPrint('[CallService] CallKit event: ${event.event}');

    switch (event.event) {
      case Event.actionCallAccept:
        _handleCallKitAccept(event.body);
        break;
      case Event.actionCallDecline:
        _handleCallKitDecline(event.body);
        break;
      case Event.actionCallEnded:
        debugPrint('[CallService] Call ended');
        break;
      case Event.actionCallTimeout:
        _handleCallKitTimeout(event.body);
        break;
      default:
        break;
    }
  }

  Future<void> _handleCallKitAccept(Map<String, dynamic>? body) async {
    if (body == null) return;

    FlutterCallkitIncoming.endAllCalls();

    final extra = body['extra'];
    if (extra == null || extra is! Map) return;

    try {
      final orderMap = Map<String, dynamic>.from(extra);
      final order = OrderModel.fromMap(orderMap);

      // ── PRE-CHECK: Accept order via API ──
      final success = await _acceptOrderViaApi(order.id);
      if (!success) {
        debugPrint('[CallService] Failed to accept order ${order.id} via API. Ignoring.');
        return;
      }

      _onAcceptController.add(order);
      debugPrint('[CallService] Order accepted (CallKit): ${order.id}');
    } catch (e) {
      debugPrint('[CallService] Failed to parse CallKit accept: $e');
    }
  }

  void _handleCallKitDecline(Map<String, dynamic>? body) {
    final callId = body?['id'] as String?;
    if (callId != null) {
      FlutterCallkitIncoming.endCall(callId);
    }

    final orderId = callId ?? body?['extra']?['id'] as String?;
    if (orderId != null) {
      _onDeclineController.add(orderId);
      debugPrint('[CallService] Order declined (CallKit): $orderId');
    }
  }

  void _handleCallKitTimeout(Map<String, dynamic>? body) {
    final callId = body?['id'] as String?;
    if (callId != null) {
      FlutterCallkitIncoming.endCall(callId);
    }

    final orderId = callId ?? body?['extra']?['id'] as String?;
    if (orderId != null) {
      _onDeclineController.add(orderId);
      debugPrint('[CallService] Order timed out (CallKit): $orderId');
    }
  }

  // ============================================================
  // Show Incoming Order Notification
  // ============================================================

  /// Show an incoming order notification.
  Future<void> showIncomingOrderCall(OrderModel order) async {
    debugPrint('[CallService] Showing notification for order: ${order.id}');

    if (Platform.isAndroid) {
      await _showAndroidNotification(order);
    } else {
      await _showIosCallKit(order);
    }
  }

  Future<void> _showAndroidNotification(OrderModel order) async {
    final amountText = '\u20B9${order.totalAmount.toStringAsFixed(2)}';
    final orderDetails = 'Order #${order.id}';

    try {
      await _notificationChannel.invokeMethod('showOrderNotification', {
        'orderId': order.id,
        'restaurantName': order.restaurantName,
        'orderDetails': orderDetails,
        'amountText': amountText,
        'orderDataJson': jsonEncode(order.toMap()),
      });
    } catch (e) {
      debugPrint('[CallService] Failed to show native notification: $e');
    }
  }

  Future<void> _showIosCallKit(OrderModel order) async {
    final amountText = '\u20B9${order.totalAmount.toStringAsFixed(2)}';

    final params = CallKitParams(
      id: order.id,
      nameCaller: order.restaurantName,
      appName: FFAppConstants.AppName,
      avatar: null,
      handle: 'Amount: $amountText',
      type: 0,
      duration: order.timeoutDuration.inMilliseconds,
      textAccept: 'Accept',
      textDecline: 'Reject',
      missedCallNotification: null,
      // CRITICAL: Sanitize extra to String-only map. The Swift CallKit plugin
      // force-unwraps values as Strings — passing List, double, or int causes
      // EXC_BREAKPOINT crash (force-unwrapped nil). Same fix as in fcm_service.dart.
      extra: _sanitizeExtraForCallKit(order.toMap()),
      ios: const IOSParams(
        iconName: 'CallKitIcon',
        handleType: 'generic',
        supportsVideo: false,
        maximumCallGroups: 1,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'default',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: false,
        supportsHolding: false,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'system_ringtone_default',
      ),
    );

    await FlutterCallkitIncoming.showCallkitIncoming(params);
  }

  /// Converts all values in a map to Strings for safe passage to the
  /// Swift CallKit plugin, which force-unwraps `extra` dict values as Strings.
  /// Non-String types (List, double, int, etc.) become nil after the cast,
  /// triggering EXC_BREAKPOINT.
  static Map<String, String> _sanitizeExtraForCallKit(Map<String, dynamic> map) {
    final sanitized = <String, String>{};
    map.forEach((key, value) {
      if (value != null) {
        sanitized[key] = value.toString();
      }
    });
    return sanitized;
  }

  // ============================================================
  // Dismiss Notifications
  // ============================================================

  /// End all active notifications (both Android native and iOS CallKit).
  Future<void> endAllCalls() async {
    if (Platform.isAndroid) {
      try {
        await _notificationChannel.invokeMethod('dismissAllOrderNotifications');
      } catch (e) {
        debugPrint('[CallService] Failed to dismiss native notifications: $e');
      }
    }
    // Also dismiss any CallKit notifications (covers edge cases)
    await FlutterCallkitIncoming.endAllCalls();
    debugPrint('[CallService] All calls/notifications ended');
  }

  /// End a specific notification by order ID.
  Future<void> endCall(String callId) async {
    if (Platform.isAndroid) {
      _dismissNativeNotification(callId);
    }
    await FlutterCallkitIncoming.endCall(callId);
    debugPrint('[CallService] Call/notification ended: $callId');
  }

  void _dismissNativeNotification(String orderId) {
    try {
      _notificationChannel.invokeMethod('dismissOrderNotification', {
        'orderId': orderId,
      });
    } catch (e) {
      debugPrint('[CallService] Failed to dismiss notification: $e');
    }
  }

  // ============================================================
  // Order Acceptance Logic (API Replacement for Firestore)
  // ============================================================

  /// Calls the UpdateRider API to accept the order and set it to 'OutForDelivery'.
  Future<bool> _acceptOrderViaApi(String orderId) async {
    try {
      final appState = FFAppState();
      final currentLocation = await getCurrentUserLocation(defaultLocation: const LatLng(0.0, 0.0));
      
      final response = await UpdateRiderCall.call(
        riderId: appState.RiderDetailsNew.masterRider.riderId.toString(),
        printerId: appState.RiderDetailsNew.masterRider.printerId.toString(),
        orderId: orderId,
        businessId: appState.RiderDetailsNew.masterRider.businessId.firstOrNull?.toString() ?? '',
        outforDelivery: true,
        status: 'OutForDelivery',
        otp: random_data.randomInteger(1000, 10000).toString(),
        trackingDisable: false,
        token: appState.RiderDetailsNew.authToken.token,
        lat: currentLocation.latitude,
        long: currentLocation.longitude,
      );

      debugPrint('[CallService] API Accept Response for $orderId: ${response.statusCode}');
      return response.succeeded;
    } catch (e) {
      debugPrint('[CallService] Error accepting order via API: $e');
      return false;
    }
  }

  /// Get all active calls (useful for debugging).
  Future<List<dynamic>> getActiveCalls() async {
    return await FlutterCallkitIncoming.activeCalls();
  }

  void dispose() {
    _callKitSubscription?.cancel();
    _nativeEventSubscription?.cancel();
    _onAcceptController.close();
    _onDeclineController.close();
    _initialized = false;
    debugPrint('[CallService] Disposed');
  }
}