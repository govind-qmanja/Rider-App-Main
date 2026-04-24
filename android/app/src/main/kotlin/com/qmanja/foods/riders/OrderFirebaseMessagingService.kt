package com.qmanja.foods.riders

import android.util.Log
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import org.json.JSONArray
import org.json.JSONObject

/**
 * Custom FirebaseMessagingService that shows our native custom notification
 * with "Accept" / "Reject" buttons instead of relying on the Dart background
 * handler (which uses CallKit and shows "Answer" / "Decline").
 *
 * This service runs even when the app is terminated. It:
 * 1. Receives the FCM data message
 * 2. Shows the native notification with custom buttons
 * 3. The Dart background handler ALSO runs and persists the order
 *
 * The Dart handler still persists the order to SharedPreferences for
 * state restoration. This service only handles the notification display.
 */
class OrderFirebaseMessagingService : FirebaseMessagingService() {

    companion object {
        private const val TAG = "OrderFCMService"
    }

    override fun onMessageReceived(message: RemoteMessage) {
        // Removed super.onMessageReceived(message) to prevent system-default notifications 
        // if the payload contains a 'notification' block. We handle everything manually.

        val data = message.data
        Log.d(TAG, "onMessageReceived called. Data: $data")
        
        if (data.isEmpty()) {
            Log.d(TAG, "Empty message data, skipping")
            return
        }

        Log.d(TAG, "Message ID: ${message.messageId}")

        // Check if this is a OneSignal message (often has "custom" json string)
        if (data.containsKey("custom") && !data.containsKey("order_id")) {
             Log.d(TAG, "OneSignal message detected (no order_id), skipping custom handling.")
             return
        }

        // STRICT CHECK: Only process if an order ID exists (case-insensitive)
        val hasOrderId = data.keys.any { it.equals("order_id", ignoreCase = true) || it.equals("orderId", ignoreCase = true) }
        
        if (!hasOrderId) {
             Log.d(TAG, "Payload missing 'order_id', skipping custom notification. Full data: $data")
             return
        }

        showOrderNotification(data)
    }

    private fun showOrderNotification(data: Map<String, String>) {
        try {
            // ─────────────────────────────────────────────────────────
            // Actual FCM payload from backend:
            //   type: "order"
            //   order_id: "<firestore doc id>"
            //   price: "<subtotal>" (or "Price")
            //   restaurant: "New Order" (or "Restaurant")
            // ─────────────────────────────────────────────────────────
            
            // Helper for case-insensitive lookup
            fun getValue(keys: List<String>): String? {
                for (key in keys) {
                    val value = data.entries.find { it.key.equals(key, ignoreCase = true) }?.value
                    if (!value.isNullOrEmpty()) return value
                }
                return null
            }

            // Payload confirmed by user:
            // { "type": "order", "order_id": "...", "price": "...", "restaurant": "New Order" }

            // Use case-insensitive lookup for critical fields
            val orderId = getValue(listOf("order_id", "orderId", "Order_id")) ?: ""
            
            // Validate type (optional but good for filtering)
            val type = getValue(listOf("type", "Type")) ?: ""
            if (type.lowercase() != "order" && orderId.isEmpty()) {
                Log.d(TAG, "Not an order notification (type: $type), skipping.")
                return
            }

            // Use the "restaurant" field from the payload.
            val restaurantName = getValue(listOf("restaurant", "Restaurant", "store")) ?: "Incoming Order"
            
            val priceString = getValue(listOf("price", "Price", "amount"))
            val totalAmount = priceString?.toDoubleOrNull() ?: 0.0
            
            // Format amount
            val amountText = if (totalAmount > 0) "\u20B9${"%.2f".format(totalAmount)}" else ""
            
            // For the subtitle/header status
            val orderDetails = if (orderId.isNotEmpty()) "Order #$orderId" else "Incoming Order..."

            // Build a JSON object that Flutter can parse...
            val orderDataJson = JSONObject().apply {
                put("id", orderId)
                put("orderType", "Delivery")
                put("restaurantName", restaurantName)
                put("status", "pending")
                put("totalAmount", totalAmount)
            }.toString()

            OrderNotificationHelper.showNotification(
                context = applicationContext,
                orderId = orderId,
                restaurantName = restaurantName, 
                orderDetails = orderDetails,
                amountText = amountText,
                orderDataJson = orderDataJson
            )

            Log.d(TAG, "Custom notification shown for order: $orderId")

        } catch (e: Exception) {
            Log.e(TAG, "Failed to show custom notification", e)
        }
    }
}