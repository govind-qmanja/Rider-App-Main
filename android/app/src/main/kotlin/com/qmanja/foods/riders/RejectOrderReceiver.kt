package com.qmanja.foods.riders

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

/**
 * BroadcastReceiver that handles the "Reject" action from the custom notification.
 *
 * When the rider taps "Reject" on the heads-up notification:
 * 1. Dismisses the notification immediately
 * 2. Sends the reject event to Flutter via a static callback
 *
 * Unlike AcceptOrderReceiver, this does NOT open the app.
 * The notification is simply dismissed and Flutter is notified in the background.
 */
class RejectOrderReceiver : BroadcastReceiver() {

    companion object {
        private const val TAG = "RejectOrderReceiver"

        /**
         * Static callback set by MainActivity when the Flutter engine is ready.
         * Used to send reject events back to Flutter without opening the app.
         */
        var onRejectCallback: ((String) -> Unit)? = null
    }

    override fun onReceive(context: Context, intent: Intent) {
        val orderId = intent.getStringExtra(OrderNotificationHelper.EXTRA_ORDER_ID) ?: return

        Log.d(TAG, "Order rejected: $orderId")

        // 1. Dismiss the notification
        OrderNotificationHelper.dismissNotification(context, orderId)

        // 2. Notify Flutter via the static callback (if app is running)
        onRejectCallback?.invoke(orderId)
    }
}