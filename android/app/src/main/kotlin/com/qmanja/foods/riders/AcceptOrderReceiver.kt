package com.qmanja.foods.riders

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

/**
 * BroadcastReceiver that handles the "Accept" action from the custom notification.
 *
 * When the rider taps "Accept" on the heads-up notification:
 * 1. Dismisses the notification immediately
 * 2. Opens MainActivity (brings app to foreground)
 * 3. Passes the order data so Flutter can process the acceptance
 *
 * Flutter receives the accept event via the MethodChannel in MainActivity,
 * which reads the intent extras and forwards to CallService/QueueService.
 */
class AcceptOrderReceiver : BroadcastReceiver() {

    companion object {
        private const val TAG = "AcceptOrderReceiver"
    }

    override fun onReceive(context: Context, intent: Intent) {
        val orderId = intent.getStringExtra(OrderNotificationHelper.EXTRA_ORDER_ID) ?: return
        val orderData = intent.getStringExtra(OrderNotificationHelper.EXTRA_ORDER_DATA) ?: ""

        Log.d(TAG, "Order accepted: $orderId")

        // 1. Dismiss the notification
        OrderNotificationHelper.dismissNotification(context, orderId)

        // 2. Launch MainActivity with accept action
        val launchIntent = Intent(context, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                    Intent.FLAG_ACTIVITY_CLEAR_TOP or
                    Intent.FLAG_ACTIVITY_SINGLE_TOP
            action = OrderNotificationHelper.ACTION_ACCEPT
            putExtra(OrderNotificationHelper.EXTRA_ORDER_ID, orderId)
            putExtra(OrderNotificationHelper.EXTRA_ORDER_DATA, orderData)
        }
        context.startActivity(launchIntent)
    }
}