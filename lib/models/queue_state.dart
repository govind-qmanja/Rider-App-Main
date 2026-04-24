// =============================================================================
// QueueState — Sealed class representing the queue finite state machine
// =============================================================================
// This is a rider app. The rider receives order notifications and
// manages their delivery lifecycle.
// Used by: QueueService
// =============================================================================

import 'order_model.dart';

/// Base class for all queue states (sealed for exhaustive switch).
sealed class QueueState {
  const QueueState();
}

/// No active or pending orders — the store is idle.
final class QueueIdle extends QueueState {
  const QueueIdle();

  @override
  String toString() => 'QueueIdle';
}

/// Store has one or more pending orders awaiting acceptance.
final class QueueHasPending extends QueueState {
  final List<OrderModel> pendingOrders;

  const QueueHasPending(this.pendingOrders);

  @override
  String toString() => 'QueueHasPending(${pendingOrders.length} orders)';
}

/// Store accepted an order, preparing for dispatch.
final class QueueOrderAccepted extends QueueState {
  final OrderModel activeOrder;
  final List<OrderModel> pendingOrders;

  const QueueOrderAccepted(this.activeOrder, {this.pendingOrders = const []});

  @override
  String toString() => 'QueueOrderAccepted(${activeOrder.id})';
}

/// Order is being dispatched/delivered.
final class QueueDelivering extends QueueState {
  final OrderModel activeOrder;
  final List<OrderModel> pendingOrders;

  const QueueDelivering(this.activeOrder, {this.pendingOrders = const []});

  @override
  String toString() => 'QueueDelivering(${activeOrder.id})';
}
