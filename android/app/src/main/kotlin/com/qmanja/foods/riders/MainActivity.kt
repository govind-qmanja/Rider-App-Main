package com.qmanja.foods.riders

import android.app.NotificationManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.PowerManager  
import android.provider.Settings
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    companion object {
        private const val TAG = "MainActivity"
        private const val BATTERY_CHANNEL = "com.qmanja.foods.riders/battery"
        private const val NOTIFICATION_CHANNEL = "com.qmanja.foods.riders/order_notification"
        private const val EVENT_CHANNEL = "com.qmanja.foods.riders/order_events"
    }

    /**
     * EventChannel sink to send native events (accept/reject from BroadcastReceivers)
     * back to the Flutter side. Flutter listens on this stream.
     */
    private var eventSink: EventChannel.EventSink? = null

    /**
     * Pending intent data from a BroadcastReceiver that arrived before
     * the Flutter engine was ready. Processed once the EventChannel sink is set.
     */
    private var pendingAcceptOrderId: String? = null
    private var pendingAcceptOrderData: String? = null
    private var pendingRejectOrderId: String? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // --- Battery & System Permissions MethodChannel ---
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, BATTERY_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "requestBatteryOptimization" -> {
                        result.success(requestBatteryOptimization())
                    }
                    "isIgnoringBatteryOptimizations" -> {
                        result.success(isIgnoringBatteryOptimizations())
                    }
                    "canDrawOverlays" -> {
                        result.success(canDrawOverlays())
                    }
                    "requestOverlayPermission" -> {
                        requestOverlayPermission()
                        result.success(true)
                    }
                    "canScheduleExactAlarms" -> {
                        result.success(canScheduleExactAlarms())
                    }
                    "requestExactAlarmPermission" -> {
                        requestExactAlarmPermission()
                        result.success(true)
                    }
                    "canUseFullScreenIntent" -> {
                        result.success(canUseFullScreenIntent())
                    }
                    "requestFullScreenIntentPermission" -> {
                        requestFullScreenIntentPermission()
                        result.success(true)
                    }
                    "openPowerManagerSettings" -> {
                        openPowerManagerSettings()
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }

        // --- Order Notification MethodChannel ---
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, NOTIFICATION_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "showOrderNotification" -> {
                        val orderId = call.argument<String>("orderId") ?: ""
                        val restaurantName = call.argument<String>("restaurantName") ?: ""
                        val orderDetails = call.argument<String>("orderDetails") ?: ""
                        val amountText = call.argument<String>("amountText") ?: ""
                        val orderDataJson = call.argument<String>("orderDataJson") ?: ""

                        OrderNotificationHelper.showNotification(
                            context = applicationContext,
                            orderId = orderId,
                            restaurantName = restaurantName,
                            orderDetails = orderDetails,
                            amountText = amountText,
                            orderDataJson = orderDataJson
                        )
                        result.success(true)
                    }
                    "dismissOrderNotification" -> {
                        val orderId = call.argument<String>("orderId") ?: ""
                        OrderNotificationHelper.dismissNotification(applicationContext, orderId)
                        result.success(true)
                    }
                    "dismissAllOrderNotifications" -> {
                        OrderNotificationHelper.dismissAllNotifications(applicationContext)
                        result.success(true)
                    }
                    else -> result.notImplemented()
                }
            }

        // --- Order Events EventChannel (native -> Flutter) ---
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL)
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                    Log.d(TAG, "EventChannel: Flutter listening")

                    // Wire up the reject callback so RejectOrderReceiver can send events
                    RejectOrderReceiver.onRejectCallback = { orderId ->
                        runOnUiThread {
                            eventSink?.success(mapOf(
                                "event" to "reject",
                                "orderId" to orderId
                            ))
                        }
                    }

                    // Flush any pending events that arrived before Flutter was ready
                    flushPendingEvents()
                }

                override fun onCancel(arguments: Any?) {
                    eventSink = null
                    RejectOrderReceiver.onRejectCallback = null
                    Log.d(TAG, "EventChannel: Flutter stopped listening")
                }
            })

        // Create the notification channel on startup
        OrderNotificationHelper.createChannel(applicationContext)

        // Process the launch intent (app may have been opened by AcceptOrderReceiver)
        handleOrderIntent(intent)
    }

    /**
     * Called when the activity receives a new intent (e.g., from AcceptOrderReceiver
     * when the app is already running, since launchMode="singleTop").
     */
    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleOrderIntent(intent)
    }

    /**
     * Check if the intent was sent by AcceptOrderReceiver and forward to Flutter.
     */
    private fun handleOrderIntent(intent: Intent?) {
        if (intent == null) return

        when (intent.action) {
            OrderNotificationHelper.ACTION_ACCEPT -> {
                val orderId = intent.getStringExtra(OrderNotificationHelper.EXTRA_ORDER_ID) ?: return
                val orderData = intent.getStringExtra(OrderNotificationHelper.EXTRA_ORDER_DATA) ?: ""

                Log.d(TAG, "Accept intent received for order: $orderId")

                // Dismiss the notification (in case it wasn't already)
                OrderNotificationHelper.dismissNotification(applicationContext, orderId)

                if (eventSink != null) {
                    eventSink?.success(mapOf(
                        "event" to "accept",
                        "orderId" to orderId,
                        "orderData" to orderData
                    ))
                } else {
                    // Flutter not ready yet — store for later delivery
                    pendingAcceptOrderId = orderId
                    pendingAcceptOrderData = orderData
                }

                // Clear the intent action to prevent re-processing
                intent.action = null
            }
        }
    }

    /**
     * Send any events that were queued before the EventChannel was ready.
     */
    private fun flushPendingEvents() {
        pendingAcceptOrderId?.let { orderId ->
            val orderData = pendingAcceptOrderData ?: ""
            eventSink?.success(mapOf(
                "event" to "accept",
                "orderId" to orderId,
                "orderData" to orderData
            ))
            Log.d(TAG, "Flushed pending accept for: $orderId")
            pendingAcceptOrderId = null
            pendingAcceptOrderData = null
        }

        pendingRejectOrderId?.let { orderId ->
            eventSink?.success(mapOf(
                "event" to "reject",
                "orderId" to orderId
            ))
            Log.d(TAG, "Flushed pending reject for: $orderId")
            pendingRejectOrderId = null
        }
    }

    // ================================================================
    // Battery Optimization Methods (unchanged)
    // ================================================================

    private fun isIgnoringBatteryOptimizations(): Boolean {
        val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
        return pm.isIgnoringBatteryOptimizations(packageName)
    }

    private fun requestBatteryOptimization(): Boolean {
        if (isIgnoringBatteryOptimizations()) return true

        try {
            val intent = Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS).apply {
                data = Uri.parse("package:$packageName")
            }
            startActivity(intent)
        } catch (e: Exception) {
            try {
                val intent = Intent(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS)
                startActivity(intent)
            } catch (_: Exception) {}
        }
        return false
    }

    private fun openPowerManagerSettings() {
        val manufacturer = Build.MANUFACTURER.lowercase()
        val intents = mutableListOf<Intent>()

        when {
            manufacturer.contains("xiaomi") || manufacturer.contains("redmi") -> {
                intents.add(Intent().apply {
                    component = ComponentName(
                        "com.miui.securitycenter",
                        "com.miui.permcenter.autostart.AutoStartManagementActivity"
                    )
                })
                intents.add(Intent().apply {
                    component = ComponentName(
                        "com.miui.powerkeeper",
                        "com.miui.powerkeeper.ui.HiddenAppsConfigActivity"
                    )
                })
            }
            manufacturer.contains("samsung") -> {
                intents.add(Intent().apply {
                    component = ComponentName(
                        "com.samsung.android.lool",
                        "com.samsung.android.sm.battery.ui.BatteryActivity"
                    )
                })
                intents.add(Intent().apply {
                    component = ComponentName(
                        "com.samsung.android.sm",
                        "com.samsung.android.sm.battery.ui.BatteryActivity"
                    )
                })
            }
            manufacturer.contains("huawei") || manufacturer.contains("honor") -> {
                intents.add(Intent().apply {
                    component = ComponentName(
                        "com.huawei.systemmanager",
                        "com.huawei.systemmanager.startupmgr.ui.StartupNormalAppListActivity"
                    )
                })
                intents.add(Intent().apply {
                    component = ComponentName(
                        "com.huawei.systemmanager",
                        "com.huawei.systemmanager.optimize.process.ProtectActivity"
                    )
                })
            }
            manufacturer.contains("oppo") -> {
                intents.add(Intent().apply {
                    component = ComponentName(
                        "com.coloros.safecenter",
                        "com.coloros.safecenter.permission.startup.StartupAppListActivity"
                    )
                })
                intents.add(Intent().apply {
                    component = ComponentName(
                        "com.oppo.safe",
                        "com.oppo.safe.permission.startup.StartupAppListActivity"
                    )
                })
            }
            manufacturer.contains("vivo") -> {
                intents.add(Intent().apply {
                    component = ComponentName(
                        "com.vivo.permissionmanager",
                        "com.vivo.permissionmanager.activity.BgStartUpManagerActivity"
                    )
                })
                intents.add(Intent().apply {
                    component = ComponentName(
                        "com.iqoo.secure",
                        "com.iqoo.secure.ui.phoneoptimize.AddWhiteListActivity"
                    )
                })
            }
            manufacturer.contains("oneplus") -> {
                intents.add(Intent().apply {
                    component = ComponentName(
                        "com.oneplus.security",
                        "com.oneplus.security.chainlaunch.view.ChainLaunchAppListActivity"
                    )
                })
            }
            manufacturer.contains("realme") -> {
                intents.add(Intent().apply {
                    component = ComponentName(
                        "com.coloros.safecenter",
                        "com.coloros.safecenter.permission.startup.StartupAppListActivity"
                    )
                })
            }
            manufacturer.contains("asus") -> {
                intents.add(Intent().apply {
                    component = ComponentName(
                        "com.asus.mobilemanager",
                        "com.asus.mobilemanager.autostart.AutoStartActivity"
                    )
                })
            }
            manufacturer.contains("lenovo") -> {
                intents.add(Intent().apply {
                    component = ComponentName(
                        "com.lenovo.security",
                        "com.lenovo.security.purebackground.PureBackgroundActivity"
                    )
                })
            }
        }

        for (intent in intents) {
            try {
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                startActivity(intent)
                return
            } catch (_: Exception) {
                continue
            }
        }

        try {
            val intent = Intent(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS)
            startActivity(intent)
        } catch (_: Exception) {
            try {
                val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
                    data = Uri.parse("package:$packageName")
                }
                startActivity(intent)
            } catch (_: Exception) {}
        }
    }

    private fun canDrawOverlays(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            Settings.canDrawOverlays(this)
        } else {
            true
        }
    }

    private fun requestOverlayPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val intent = Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION, Uri.parse("package:$packageName"))
            startActivity(intent)
        }
    }

    private fun canScheduleExactAlarms(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val alarmManager = getSystemService(Context.ALARM_SERVICE) as android.app.AlarmManager
            alarmManager.canScheduleExactAlarms()
        } else {
            true
        }
    }

    private fun requestExactAlarmPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val intent = Intent(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM, Uri.parse("package:$packageName"))
            startActivity(intent)
        }
    }

    private fun canUseFullScreenIntent(): Boolean {
        return if (Build.VERSION.SDK_INT >= 34) {
            val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            nm.canUseFullScreenIntent()
        } else {
            true // Auto-granted on Android 13 and below
        }
    }

    private fun requestFullScreenIntentPermission() {
        if (Build.VERSION.SDK_INT >= 34) {
            try {
                val intent = Intent(Settings.ACTION_MANAGE_APP_USE_FULL_SCREEN_INTENT, Uri.parse("package:$packageName"))
                startActivity(intent)
            } catch (e: Exception) {
                Log.w(TAG, "Failed to open full screen intent settings: $e")
            }
        }
    }
}