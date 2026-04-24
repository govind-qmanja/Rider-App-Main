// =============================================================================
// OrderModel — Lightweight FCM notification payload for order alerts
// =============================================================================
//
// PURPOSE: This model holds the minimal order data received via FCM push
//          notifications. It is used ONLY in the notification pipeline:
//
//            FCM push → FcmService (parse) → CallService (display notification)
//                                          → QueueService (pending queue)
//
// THIS IS NOT the full order model. The real order data lives in:
//   → OrdersRecord  (backend/schema/orders_record.dart)
//     Comes from Firestore 'Orders' collection, used by all UI pages.
//
// Also NOT related to:
//   → OrderModelStruct (backend/schema/structs/order_model_struct.dart)
//     A FlutterFlow struct for order line items within the Firestore schema.
//
// =============================================================================

/// Represents a single item within an order.
class OrderItem {
  final String name;
  final int quantity;
  final double price;

  const OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });

  /// Deserialize from a Map (used when restoring from SharedPreferences/FCM).
  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      name: map['name'] as String? ?? 'Unknown item',
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Serialize to a Map (used when persisting to SharedPreferences/FCM).
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'price': price,
    };
  }

  @override
  String toString() => 'OrderItem(name: $name, qty: $quantity, price: $price)';
}

/// Represents a delivery order in the queue system.
///
/// Lifecycle:
///   pending → accepted → delivering → delivered
///                  ↘ declined
///                  ↘ expired (auto, via timeout)
class OrderModel {
  final String id;
  final String orderType;
  final String restaurantName;
  final String customerName;
  final String subtitle;
  final String status;
  final List<OrderItem> items;
  final double totalAmount;
  final DateTime createdAt;
  final DateTime receivedAt;
  final Duration timeoutDuration;

  const OrderModel({
    required this.id,
    required this.orderType,
    required this.restaurantName,
    required this.customerName,
    required this.subtitle,
    required this.status,
    required this.items,
    required this.totalAmount,
    required this.createdAt,
    required this.receivedAt,
    this.timeoutDuration = const Duration(seconds: 45),
  });

  /// Whether this order has expired (exceeded its timeout window).
  bool get isExpired =>
      DateTime.now().difference(receivedAt) > timeoutDuration;

  /// Returns a copy of this order with selected fields replaced.
  OrderModel copyWith({
    String? id,
    String? orderType,
    String? restaurantName,
    String? customerName,
    String? subtitle,
    String? status,
    List<OrderItem>? items,
    double? totalAmount,
    DateTime? createdAt,
    DateTime? receivedAt,
    Duration? timeoutDuration,
  }) {
    return OrderModel(
      id: id ?? this.id,
      orderType: orderType ?? this.orderType,
      restaurantName: restaurantName ?? this.restaurantName,
      customerName: customerName ?? this.customerName,
      subtitle: subtitle ?? this.subtitle,
      status: status ?? this.status,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      createdAt: createdAt ?? this.createdAt,
      receivedAt: receivedAt ?? this.receivedAt,
      timeoutDuration: timeoutDuration ?? this.timeoutDuration,
    );
  }

  /// Deserialize from a Map (used when restoring from SharedPreferences/FCM).
  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] as String? ?? '',
      orderType: map['orderType'] as String? ?? 'Delivery',
      restaurantName: map['restaurantName'] as String? ?? 'Unknown',
      customerName: map['customerName'] as String? ?? 'Customer',
      subtitle: map['subtitle'] as String? ?? '',
      status: map['status'] as String? ?? 'pending',
      items: (map['items'] as List<dynamic>?)
              ?.map((e) => OrderItem.fromMap(e as Map<String, dynamic>))
              .toList() ??
          const [],
      totalAmount: (map['totalAmount'] as num?)?.toDouble() ?? 0.0,
      receivedAt: DateTime.tryParse(map['receivedAt']?.toString() ?? '') ?? DateTime.now(),
      createdAt: DateTime.tryParse(map['createdAt']?.toString() ?? '') ?? DateTime.now(),
      timeoutDuration: Duration(
        seconds: int.tryParse(map['timeoutSeconds']?.toString() ?? '') ?? 45,
      ),
    );
  }

  /// Serialize to a Map (used when persisting to SharedPreferences/FCM).
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderType': orderType,
      'restaurantName': restaurantName,
      'customerName': customerName,
      'subtitle': subtitle,
      'status': status,
      'items': items.map((e) => e.toMap()).toList(),
      'totalAmount': totalAmount,
      'createdAt': createdAt.toIso8601String(),
      'receivedAt': receivedAt.toIso8601String(),
      'timeoutSeconds': timeoutDuration.inSeconds,
    };
  }

  @override
  String toString() =>
      'OrderModel(id: $id, restaurant: $restaurantName, status: $status)';
}
