package com.qmanja.foods.riders

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.PowerManager
import android.util.Log
import android.widget.RemoteViews
import androidx.core.app.NotificationCompat

/**
 * Builds and shows a full-screen notification for incoming delivery orders.
 *
 * Strategy:
 * 1. Posts a notification with fullScreenIntent -> IncomingOrderActivity
 *    (Android auto-launches this when screen is off / device is locked)
 * 2. ALSO explicitly starts IncomingOrderActivity when screen is ON,
 *    because Android only shows a heads-up banner (not full screen) for
 *    notifications when the screen is already on.
 *
 * This guarantees the store operator ALWAYS sees a full-screen order alert,
 * regardless of whether the phone is locked, screen-off, or in use.
 *
 * The notification stays in the tray as a backup (with Accept/Reject buttons)
 * in case the activity is dismissed.
 */
object OrderNotificationHelper {

    // UPDATE: Changed ID to force channel recreation with HIGH importance
    const val CHANNEL_ID = "incoming_order_high_v2"
    const val CHANNEL_NAME = "Incoming Orders"
    const val NOTIFICATION_ID_BASE = 9000

    const val ACTION_ACCEPT = "com.qmanja.foods.riders.ACTION_ACCEPT_ORDER"
    const val ACTION_REJECT = "com.qmanja.foods.riders.ACTION_REJECT_ORDER"
    const val EXTRA_ORDER_ID = "extra_order_id"
    const val EXTRA_ORDER_DATA = "extra_order_data"

    /**
     * Create the high-importance notification channel (idempotent).
     */
    fun createChannel(context: Context) {
        val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        // Use IMPORTANCE_HIGH to allow Full Screen Intent launches.
        // Critical: IMPORTANCE_LOW prevents the system from launching the activity on lock screen.
        val channel = NotificationChannel(
            CHANNEL_ID,
            CHANNEL_NAME,
            NotificationManager.IMPORTANCE_HIGH
        ).apply {
            description = "Incoming delivery order alerts"
            setShowBadge(true)
            lockscreenVisibility = NotificationCompat.VISIBILITY_PUBLIC
            // Enable lights/vibration to ensure high priority handling
            enableLights(true)
            enableVibration(true)
        }

        manager.createNotificationChannel(channel)
    }

    /**
     * Show the custom incoming order notification with "Accept" and "Reject" buttons.
     *
     * @param context Application context
     * @param orderId Unique order identifier
     * @param restaurantName Name of the restaurant
     * @param orderDetails Items count, amount, distance summary
     * @param amountText Formatted amount (e.g., "₹27.45")
     * @param orderDataJson Full order data as JSON string (passed to Flutter on accept)
     */
    fun showNotification(
        context: Context,
        orderId: String,
        restaurantName: String,
        orderDetails: String,
        amountText: String,
        orderDataJson: String
    ) {
        createChannel(context)

        val notificationId = orderId.hashCode().let {
            if (it == 0) NOTIFICATION_ID_BASE else it
        }

        // --- PendingIntents for Accept and Reject ---

        val acceptIntent = Intent(context, AcceptOrderReceiver::class.java).apply {
            action = ACTION_ACCEPT
            putExtra(EXTRA_ORDER_ID, orderId)
            putExtra(EXTRA_ORDER_DATA, orderDataJson)
        }
        val acceptPendingIntent = PendingIntent.getBroadcast(
            context,
            notificationId + 1,
            acceptIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val rejectIntent = Intent(context, RejectOrderReceiver::class.java).apply {
            action = ACTION_REJECT
            putExtra(EXTRA_ORDER_ID, orderId)
        }
        val rejectPendingIntent = PendingIntent.getBroadcast(
            context,
            notificationId + 2,
            rejectIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        // --- Tap intent (opens app) ---
        val tapIntent = Intent(context, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            putExtra(EXTRA_ORDER_ID, orderId)
            putExtra(EXTRA_ORDER_DATA, orderDataJson)
        }
        val tapPendingIntent = PendingIntent.getActivity(
            context,
            notificationId + 3,
            tapIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        // --- Full-screen intent (for lock screen / screen off) ---
        // Launches a dedicated full-screen Activity with order details and
        // large Accept / Reject buttons. This always pops over the lock screen.
        val fullScreenIntent = Intent(context, IncomingOrderActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                    Intent.FLAG_ACTIVITY_CLEAR_TOP or
                    Intent.FLAG_ACTIVITY_NO_USER_ACTION
            putExtra(EXTRA_ORDER_ID, orderId)
            putExtra(EXTRA_ORDER_DATA, orderDataJson)
            putExtra("restaurantName", restaurantName)
            putExtra("orderDetails", orderDetails)
            putExtra("amountText", amountText)
        }
        val fullScreenPendingIntent = PendingIntent.getActivity(
            context,
            notificationId + 4,
            fullScreenIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        // --- Custom layout (expanded) ---
        val expandedView = RemoteViews(context.packageName, R.layout.notification_incoming_order).apply {
            setTextViewText(R.id.tv_restaurant_name, restaurantName)
            setTextViewText(R.id.tv_order_details, orderDetails)
            setOnClickPendingIntent(R.id.btn_accept, acceptPendingIntent)
            setOnClickPendingIntent(R.id.btn_reject, rejectPendingIntent)
        }

        // --- Custom layout (collapsed / heads-up) ---
        val collapsedView = RemoteViews(context.packageName, R.layout.notification_incoming_order_headsup).apply {
            setTextViewText(R.id.tv_restaurant_name, restaurantName)
            setTextViewText(R.id.tv_amount, amountText)
            setTextViewText(R.id.tv_order_details, orderDetails)
            setOnClickPendingIntent(R.id.btn_accept, acceptPendingIntent)
            setOnClickPendingIntent(R.id.btn_reject, rejectPendingIntent)
        }

        // --- Build notification ---
        // Priority MAX to ensure Full Screen Intent works on all Android versions.
        val builder = NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle(restaurantName)
            .setContentText(orderDetails)
            .setPriority(NotificationCompat.PRIORITY_MAX) // CHANGED to MAX
            .setCategory(NotificationCompat.CATEGORY_CALL)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setAutoCancel(false)
            .setOngoing(true)
            // Removed setSilent(true) - we need high priority behavior
            .setContentIntent(tapPendingIntent)
            .setFullScreenIntent(fullScreenPendingIntent, true) // High priority ensures this fires
            .setCustomContentView(collapsedView)
            .setCustomBigContentView(expandedView)
            .setStyle(NotificationCompat.DecoratedCustomViewStyle())
            .setColor(0xFF1A237E.toInt())
            .setColorized(true)
            .setTimeoutAfter(45_000)

        val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        manager.notify(notificationId, builder.build())

        // ALWAYS launch IncomingOrderActivity directly, regardless of screen state.
        // On Android 14+ (SDK 34+), USE_FULL_SCREEN_INTENT is no longer auto-granted,
        // so fullScreenIntent alone won't work on the lock screen.
        // We use a WakeLock to force the screen ON, then launch the activity.
        try {
            val pm = context.getSystemService(Context.POWER_SERVICE) as PowerManager
            
            // If screen is OFF or locked, wake it up
            if (!pm.isInteractive) {
                @Suppress("DEPRECATION")
                val wakeLock = pm.newWakeLock(
                    PowerManager.FULL_WAKE_LOCK or
                    PowerManager.ACQUIRE_CAUSES_WAKEUP or
                    PowerManager.ON_AFTER_RELEASE,
                    "OrderNotification:WakeLock"
                )
                wakeLock.acquire(10_000L)  // Hold for 10 seconds max
                Log.d("OrderNotificationHelper", "Screen OFF → WakeLock acquired to turn screen ON")
            }

            // Launch IncomingOrderActivity directly
            val directLaunch = Intent(context, IncomingOrderActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                        Intent.FLAG_ACTIVITY_CLEAR_TOP or
                        Intent.FLAG_ACTIVITY_NO_USER_ACTION
                putExtra(EXTRA_ORDER_ID, orderId)
                putExtra(EXTRA_ORDER_DATA, orderDataJson)
                putExtra("restaurantName", restaurantName)
                putExtra("orderDetails", orderDetails)
                putExtra("amountText", amountText)
            }
            context.startActivity(directLaunch)
            Log.d("OrderNotificationHelper", "Launched IncomingOrderActivity directly")
        } catch (e: Exception) {
            Log.w("OrderNotificationHelper", "Failed to launch full-screen activity: $e")
            // The notification with fullScreenIntent is still posted as fallback
        }
    }

    /**
     * Dismiss a specific order notification.
     */
    fun dismissNotification(context: Context, orderId: String) {
        val notificationId = orderId.hashCode().let {
            if (it == 0) NOTIFICATION_ID_BASE else it
        }
        val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        manager.cancel(notificationId)
    }

    /**
     * Dismiss all order notifications.
     */
    fun dismissAllNotifications(context: Context) {
        val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        manager.cancelAll()
    }
}