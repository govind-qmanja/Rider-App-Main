import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/order_model.dart';
import '../models/queue_state.dart';
import 'call_service.dart';
import 'fcm_service.dart';
// CHANGE: Terminology updated to 'Rider' context. This is a rider app.
//         Location tracking is enabled/managed via native channels and APIs.
// CHANGE: Removed 'import storage_service.dart' — StorageService was an
//         unnecessary wrapper. Using FirebaseAuth UID directly instead.

/// The single source of truth for all order lifecycle management.
///
/// CHANGE: Updated terminology — this is a rider app.
/// The "Rider" receives order notifications and accepts them for delivery.
///
/// Implements a formal finite state machine with these states:
/// - QueueIdle: No orders pending or active
/// - QueueHasPending: One or more orders awaiting acceptance
/// - QueueOrderAccepted: Rider accepted an order, preparing for pick-up
/// - QueueDelivering: Rider is on the way to the customer
///
/// All state transitions are:
/// - Idempotent: Double-accept, double-decline are safe no-ops
/// - Persisted: Survives app restart via SharedPreferences
/// - Audited: Every transition is logged with timestamp
///
/// CallKit Integration:
/// - Shows call-style notification when new orders arrive
/// - Dismisses notification when order is accepted/declined/expired
class QueueService extends ChangeNotifier {
  QueueService._internal() {
    CallService().onAccept.listen((order) {
      debugPrint('[QueueService] Received accept event from CallService: ${order.id}');
      acceptOrder(order);
    });

    CallService().onDecline.listen((orderId) {
      debugPrint('[QueueService] Received decline event from CallService: $orderId');
      declineOrder(orderId);
    });
  }
  static final QueueService instance = QueueService._internal();
  factory QueueService() => instance;

  // Persistence keys
  static const String _pendingOrdersKey = 'queue_pending_orders';
  static const String _activeOrderKey = 'queue_active_order';
  static const String _isDeliveringKey = 'queue_is_delivering';
  static const String _auditLogKey = 'queue_audit_log';
  static const int _maxAuditEntries = 200;

  // State
  final List<OrderModel> _pendingOrders = [];
  OrderModel? _activeOrder;
  bool _isDelivering = false;
  Timer? _expirationTimer;

  String? _pendingNavigationOrderId;
  OrderModel? _pendingNavigationOrder;
  void Function(String orderId, OrderModel? order)? _onOrderAcceptedCallback;

  /// Callback invoked when an order is accepted to navigate UI.
  set onOrderAcceptedCallback(void Function(String orderId, OrderModel? order)? callback) {
    _onOrderAcceptedCallback = callback;
    if (callback != null && _pendingNavigationOrderId != null) {
      debugPrint('[QueueService] Flushing pending navigation for order: $_pendingNavigationOrderId');
      callback(_pendingNavigationOrderId!, _pendingNavigationOrder);
      _pendingNavigationOrderId = null;
      _pendingNavigationOrder = null;
    }
  }

  /// Current queue state as a sealed class for exhaustive switch.
  QueueState get state {
    if (_activeOrder != null) {
      if (_isDelivering) {
        return QueueDelivering(_activeOrder!, pendingOrders: _pendingOrders);
      }
      return QueueOrderAccepted(_activeOrder!, pendingOrders: _pendingOrders);
    }
    if (_pendingOrders.isNotEmpty) {
      return QueueHasPending(List.unmodifiable(_pendingOrders));
    }
    return const QueueIdle();
  }

  /// Unmodifiable view of pending orders.
  List<OrderModel> get pendingOrders => List.unmodifiable(_pendingOrders);

  /// The currently active order (accepted or delivering).
  OrderModel? get activeOrder => _activeOrder;

  /// Whether the rider is actively delivering this order.
  bool get isDelivering => _isDelivering;

  // ============================================================
  // State Transitions
  // ============================================================

  /// Adds an order to the pending queue.
  /// Idempotent: Duplicate order IDs are silently ignored.
  ///
  /// When [showCallKit] is true (default), shows a full-screen
  /// lock screen notification via CallKit. Set to false when
  /// restoring from persistence to avoid duplicate notifications.
  void enqueueOrder(OrderModel order, {bool showCallKit = true}) {
    // Deduplicate by ID
    if (_pendingOrders.any((o) => o.id == order.id)) {
      debugPrint('[QueueService] Duplicate order ignored: ${order.id}');
      return;
    }
    if (_activeOrder?.id == order.id) {
      debugPrint('[QueueService] Order already active: ${order.id}');
      return;
    }

    final oldState = state.toString();
    _pendingOrders.add(order);
    _startExpirationTimer();
    _persist();
    _logTransition(oldState, state.toString(), order.id, 'enqueue');
    notifyListeners();
    debugPrint('[QueueService] Order enqueued: ${order.id}');

    // Show CallKit lock screen notification for the new order
    if (showCallKit) {
      CallService().showIncomingOrderCall(order);
    }
  }

  /// Accepts an order from the pending queue by ID.
  /// Transition: has_pending -> order_accepted
  void acceptOrderById(String orderId) {
    // Idempotent: Already accepted this order
    if (_activeOrder?.id == orderId) {
      debugPrint('[QueueService] Order already active: $orderId');
      if (_onOrderAcceptedCallback != null) {
        _onOrderAcceptedCallback!(orderId, null);
      } else {
        _pendingNavigationOrderId = orderId;
        _pendingNavigationOrder = null;
      }
      return;
    }

    // Clear any stale active/delivering order to accept the new one
    if (_activeOrder != null) {
      debugPrint('[QueueService] Clearing previous active order: ${_activeOrder!.id}');
      _activeOrder = null;
      _isDelivering = false;
    }

    // Find in pending
    final index = _pendingOrders.indexWhere((o) => o.id == orderId);
    if (index == -1) {
      debugPrint('[QueueService] Order not found in pending: $orderId');
      return;
    }

    final oldState = state.toString();
    _activeOrder = _pendingOrders.removeAt(index).copyWith(status: 'accepted');
    _persist();
    _logTransition(oldState, state.toString(), orderId, 'accept');
    notifyListeners();
    debugPrint('[QueueService] Order accepted: $orderId');

    // End the CallKit call immediately so the "on-call" screen never shows
    CallService().endAllCalls();

    // Notify UI for navigation
    // Notify UI for navigation
    if (_onOrderAcceptedCallback != null) {
      _onOrderAcceptedCallback!(orderId, null);
    } else {
      debugPrint('[QueueService] No callback set, storing pending navigation: $orderId');
      _pendingNavigationOrderId = orderId;
      _pendingNavigationOrder = null;
    }
  }

  /// Accepts an order directly (from CallKit callback with full order).
  void acceptOrder(OrderModel order) {
    // Idempotent: Already accepted this order
    if (_activeOrder?.id == order.id) {
      debugPrint('[QueueService] Order already active: ${order.id}');
      // We still want to navigate the user if they tapped the accept button
      if (_onOrderAcceptedCallback != null) {
        _onOrderAcceptedCallback!(order.id, order);
      } else {
        _pendingNavigationOrderId = order.id;
        _pendingNavigationOrder = order;
      }
      return;
    }

    // Clear any stale active/delivering order to accept the new one
    if (_activeOrder != null) {
      debugPrint('[QueueService] Clearing previous active order: ${_activeOrder!.id}');
      _activeOrder = null;
      _isDelivering = false;
    }

    final oldState = state.toString();
    // Remove from pending if exists
    _pendingOrders.removeWhere((o) => o.id == order.id);
    _activeOrder = order.copyWith(status: 'accepted');
    _persist();
    _logTransition(oldState, state.toString(), order.id, 'accept_direct');
    notifyListeners();
    debugPrint('[QueueService] Order accepted directly: ${order.id}');

    // Location tracking could be enabled here in the future
    // e.g., LocationService.setHighFrequency();

    // API update is already handled by CallService._acceptOrderViaApi
    
    // End the CallKit call immediately so the "on-call" screen never shows
    CallService().endAllCalls();

    // Also clear the persisted FCM orders to prevent the same order from
    // being restored again by _restorePendingFcmOrders (race condition).
    _clearAcceptedOrderFromFcmPersistence(order.id);

    // Notify UI for navigation
    if (_onOrderAcceptedCallback != null) {
      _onOrderAcceptedCallback!(order.id, order);
    } else {
      debugPrint('[QueueService] No callback set, storing pending navigation: ${order.id}');
      _pendingNavigationOrderId = order.id;
      _pendingNavigationOrder = order;
    }
  }



  /// Starts delivery for the active order.
  /// Transition: order_accepted -> delivering
  void startDelivery() {
    if (_activeOrder == null) {
      debugPrint('[QueueService] No active order to start delivery');
      return;
    }
    if (_isDelivering) {
      debugPrint('[QueueService] Already delivering');
      return;
    }

    final oldState = state.toString();
    _isDelivering = true;
    _activeOrder = _activeOrder!.copyWith(status: 'delivering');
    _persist();
    _logTransition(oldState, state.toString(), _activeOrder!.id, 'start_delivery');
    notifyListeners();
    debugPrint('[QueueService] Delivery started: ${_activeOrder!.id}');
  }

  /// Completes the current delivery.
  /// Transition: delivering -> idle or has_pending
  void completeDelivery() {
    if (_activeOrder == null || !_isDelivering) {
      debugPrint('[QueueService] No delivery to complete');
      return;
    }

    final oldState = state.toString();
    final completedId = _activeOrder!.id;
    _activeOrder = null;
    _isDelivering = false;
    _persist();
    _logTransition(oldState, state.toString(), completedId, 'complete');
    notifyListeners();
    debugPrint('[QueueService] Delivery completed: $completedId');

    // Location tracking could be set to normal frequency here
    // e.g., LocationService.setNormalFrequency();
  }

  /// Declines/removes an order from the pending queue.
  void declineOrder(String orderId) {
    final index = _pendingOrders.indexWhere((o) => o.id == orderId);
    if (index == -1) {
      debugPrint('[QueueService] Order not in pending: $orderId');
      return;
    }

    final oldState = state.toString();
    _pendingOrders.removeAt(index);
    _persist();
    _logTransition(oldState, state.toString(), orderId, 'decline');
    notifyListeners();
    debugPrint('[QueueService] Order declined: $orderId');

    // End the CallKit call immediately
    CallService().endCall(orderId);
  }

  /// Cancels the current active order (returns to idle or has_pending).
  void cancelActiveOrder() {
    if (_activeOrder == null) {
      debugPrint('[QueueService] No active order to cancel');
      return;
    }

    final oldState = state.toString();
    final cancelledId = _activeOrder!.id;
    _activeOrder = null;
    _isDelivering = false;
    _persist();
    _logTransition(oldState, state.toString(), cancelledId, 'cancel');
    notifyListeners();
    debugPrint('[QueueService] Order cancelled: $cancelledId');

    // Location tracking could be set to normal frequency here
    // e.g., LocationService.setNormalFrequency();
  }

  // ============================================================
  // FCM Persistence Cleanup
  // ============================================================

  /// Removes an accepted order from the background FCM persistence store.
  /// Prevents the race condition where _restorePendingFcmOrders re-enqueues
  /// an order that was already accepted from the lock screen CallKit.
  Future<void> _clearAcceptedOrderFromFcmPersistence(String orderId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.reload();
      final ordersJson =
          prefs.getStringList(FcmService.pendingFcmOrdersKey) ?? [];
      if (ordersJson.isEmpty) return;

      final filtered = ordersJson.where((json) {
        try {
          final map = jsonDecode(json) as Map<String, dynamic>;
          return map['id'] != orderId;
        } catch (_) {
          return true; // Keep unparseable entries (defensive)
        }
      }).toList();

      if (filtered.length != ordersJson.length) {
        await prefs.setStringList(FcmService.pendingFcmOrdersKey, filtered);
        debugPrint(
          '[QueueService] Cleared accepted order $orderId from FCM persistence',
        );
      }
    } catch (e) {
      debugPrint('[QueueService] Failed to clear FCM persistence: $e');
    }
  }

  // ============================================================
  // Expiration Timer
  // ============================================================

  void _startExpirationTimer() {
    _expirationTimer?.cancel();
    _expirationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _checkExpirations();
    });
  }

  void _checkExpirations() {
    final expired = _pendingOrders.where((o) => o.isExpired).toList();
    if (expired.isEmpty) return;

    for (final order in expired) {
      final oldState = state.toString();
      _pendingOrders.remove(order);
      _logTransition(oldState, state.toString(), order.id, 'expire');
      debugPrint('[QueueService] Order expired: ${order.id}');

      // Dismiss the CallKit notification for expired order
      CallService().endCall(order.id);
    }

    if (expired.isNotEmpty) {
      _persist();
      notifyListeners();
    }

    // Stop timer if no pending orders
    if (_pendingOrders.isEmpty) {
      _expirationTimer?.cancel();
      _expirationTimer = null;
    }
  }

  // ============================================================
  // Persistence
  // ============================================================

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();

    // Pending orders
    final pendingJson = _pendingOrders.map((o) => jsonEncode(o.toMap())).toList();
    await prefs.setStringList(_pendingOrdersKey, pendingJson);

    // Active order
    if (_activeOrder != null) {
      await prefs.setString(_activeOrderKey, jsonEncode(_activeOrder!.toMap()));
    } else {
      await prefs.remove(_activeOrderKey);
    }

    // Delivering flag
    await prefs.setBool(_isDeliveringKey, _isDelivering);
  }

  /// Restores state from SharedPreferences on cold start.
  Future<void> restoreState() async {
    final prefs = await SharedPreferences.getInstance();

    // Restore pending orders (without showing CallKit - they may already have notifications)
    final pendingJson = prefs.getStringList(_pendingOrdersKey) ?? [];
    _pendingOrders.clear();
    for (final json in pendingJson) {
      try {
        final map = jsonDecode(json) as Map<String, dynamic>;
        final order = OrderModel.fromMap(map);
        // Skip already expired orders
        if (!order.isExpired) {
          _pendingOrders.add(order);
        }
      } catch (e) {
        debugPrint('[QueueService] Failed to restore pending order: $e');
      }
    }

    // Restore active order
    final activeJson = prefs.getString(_activeOrderKey);
    if (activeJson != null) {
      try {
        final map = jsonDecode(activeJson) as Map<String, dynamic>;
        _activeOrder = OrderModel.fromMap(map);
      } catch (e) {
        debugPrint('[QueueService] Failed to restore active order: $e');
      }
    }

    // Restore delivering flag
    _isDelivering = prefs.getBool(_isDeliveringKey) ?? false;

    // Start expiration timer if we have pending orders
    if (_pendingOrders.isNotEmpty) {
      _startExpirationTimer();
    }

    debugPrint('[QueueService] State restored: ${state.toString()}');
    notifyListeners();
  }

  /// Clears all queue state (for debugging/testing).
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pendingOrdersKey);
    await prefs.remove(_activeOrderKey);
    await prefs.remove(_isDeliveringKey);

    _pendingOrders.clear();
    _activeOrder = null;
    _isDelivering = false;
    _expirationTimer?.cancel();
    _expirationTimer = null;

    // End all CallKit notifications
    await CallService().endAllCalls();

    notifyListeners();
    debugPrint('[QueueService] All state cleared');
  }

  // ============================================================
  // Audit Log
  // ============================================================

  Future<void> _logTransition(
    String fromState,
    String toState,
    String orderId,
    String trigger,
  ) async {
    final entry = {
      'timestamp': DateTime.now().toIso8601String(),
      'from': fromState,
      'to': toState,
      'orderId': orderId,
      'trigger': trigger,
    };

    final prefs = await SharedPreferences.getInstance();
    final log = prefs.getStringList(_auditLogKey) ?? [];
    log.add(jsonEncode(entry));

    // Keep only recent entries
    if (log.length > _maxAuditEntries) {
      log.removeRange(0, log.length - _maxAuditEntries);
    }

    await prefs.setStringList(_auditLogKey, log);
  }

  /// Retrieves the audit log for debugging.
  Future<List<Map<String, dynamic>>> getAuditLog() async {
    final prefs = await SharedPreferences.getInstance();
    final log = prefs.getStringList(_auditLogKey) ?? [];
    return log.map((json) => jsonDecode(json) as Map<String, dynamic>).toList();
  }

  // ============================================================
  // Firestore Sync
  // ============================================================

  /// Updates order status (local state only).
  Future<void> updateStatus(String status) async {
    if (_activeOrder == null) return;

    final oldState = state.toString();
    _activeOrder = _activeOrder!.copyWith(status: status);
    
    if (status == 'delivered') {
      _isDelivering = false;
      CallService().endAllCalls();
    } else if (status == 'delivering') {
      _isDelivering = true;
    }

    _persist();
    _logTransition(oldState, state.toString(), _activeOrder!.id, 'status_update');
    notifyListeners();
    debugPrint('[QueueService] Local status updated: ${_activeOrder!.id} -> $status');
  }

  @override
  void dispose() {
    _expirationTimer?.cancel();
    super.dispose();
  }
}