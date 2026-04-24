package com.qmanja.foods.riders

import androidx.appcompat.app.AppCompatActivity
import android.app.KeyguardManager
import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.media.MediaPlayer
import android.media.RingtoneManager
import android.os.Build
import android.os.Bundle
import android.os.PowerManager
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import android.util.Log
import android.view.WindowManager
import android.widget.TextView

/**
 * Full-screen activity that displays incoming delivery order details.
 *
 * This activity is launched by the notification's fullScreenIntent when the
 * device is locked or the screen is off. It:
 * - Turns on the screen and shows over the lock screen
 * - Displays restaurant name, order details, amount
 * - Provides Accept and Stop Alert buttons
 *
 * Accept: shows Toast, dismisses notification, opens MainActivity with order data
 * Stop Alert: stops sound/vibration, keeps notification in tray, order stays pending
 */
class IncomingOrderActivity : AppCompatActivity() {

    companion object {
        private const val TAG = "IncomingOrderActivity"
        private const val WAKELOCK_TIMEOUT_MS = 60_000L // 60 seconds for wake lock
    }

    private var orderId: String? = null
    private var orderDataJson: String? = null
    private var wakeLock: PowerManager.WakeLock? = null
    private var mediaPlayer: MediaPlayer? = null
    private var vibrator: Vibrator? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Ensure this activity shows on lock screen and turns on the display
        turnOnScreen()

        // Start ringtone sound and vibration
        startAlerts()

        setContentView(R.layout.activity_incoming_order)

        updateUI(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        // Update the intent property of the activity
        this.intent = intent
        // Refresh the UI with the new order data
        updateUI(intent)
        
        // Reset timeout
        timeoutHandler.removeCallbacks(timeoutRunnable)
        timeoutHandler.postDelayed(timeoutRunnable, 30_000L)
    }

    private val timeoutHandler = android.os.Handler(android.os.Looper.getMainLooper())
    private val timeoutRunnable = Runnable {
        Log.d(TAG, "30s timeout reached, stopping alert and closing activity")
        stopAlerts()
        finish()
    }

    override fun onStart() {
        super.onStart()
        // Start 30s timeout
        timeoutHandler.postDelayed(timeoutRunnable, 30_000L)
    }

    override fun onStop() {
        super.onStop()
        stopAlerts()
        timeoutHandler.removeCallbacks(timeoutRunnable)
    }

    private fun updateUI(intent: Intent) {
        // Extract order data from intent
        orderId = intent.getStringExtra(OrderNotificationHelper.EXTRA_ORDER_ID)
        orderDataJson = intent.getStringExtra(OrderNotificationHelper.EXTRA_ORDER_DATA)

        val restaurantName = intent.getStringExtra("restaurantName") ?: "New Order"
        val orderDetails = intent.getStringExtra("orderDetails") ?: "Incoming Order..."
        val amountText = intent.getStringExtra("amountText") ?: ""

        if (orderId == null) {
            Log.e(TAG, "No orderId in intent, finishing")
            finish()
            return
        }

        Log.d(TAG, "Showing full-screen order: $orderId")

        // Populate UI
        findViewById<TextView>(R.id.tv_header_label)?.text = orderDetails
        findViewById<TextView>(R.id.tv_restaurant_name)?.text = restaurantName
        findViewById<TextView>(R.id.tv_amount)?.text = amountText

        // Wire up buttons
        // ACCEPT Button
        findViewById<android.widget.Button>(R.id.btn_view_details)?.apply {
            setOnClickListener { onViewDetails() }

        }

        // STOP ALERT Button
        findViewById<android.widget.Button>(R.id.btn_stop_alert)?.setOnClickListener {
            onStopAlert()
        }

        // VIEW DETAIL Button (Just opens app)
        findViewById<android.widget.Button>(R.id.btn_open_app_main)?.setOnClickListener {
            onOpenApp()
        }
    }

    // Stop sound if screen turns off (Power Button) or App goes background
    // (onStop already implemented above with timeout clearing)

    // Mute sound on Volume Keys
    override fun onKeyDown(keyCode: Int, event: android.view.KeyEvent?): Boolean {
        if (keyCode == android.view.KeyEvent.KEYCODE_VOLUME_DOWN ||
            keyCode == android.view.KeyEvent.KEYCODE_VOLUME_UP) {
            stopAlerts()
            return true
        }
        return super.onKeyDown(keyCode, event)
    }

    // ACCEPT: Dismiss Notification -> Launch App (API confirmation happens on Flutter side)
    private fun onViewDetails() {
        Log.d(TAG, "Accept clicked: $orderId")

        stopAlerts()

        // Show a neutral processing toast — NOT "success" since the API call
        // hasn't happened yet. Flutter's CallService._acceptOrderViaApi will
        // handle the actual backend confirmation and show the real result.
        android.widget.Toast.makeText(
            this,
            "Processing order…",
            android.widget.Toast.LENGTH_SHORT
        ).show()

        // Dismiss notification (order is handled)
        orderId?.let { OrderNotificationHelper.dismissNotification(applicationContext, it) }

        // Launch MainActivity with accept action
        val launchIntent = Intent(this, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                    Intent.FLAG_ACTIVITY_CLEAR_TOP or
                    Intent.FLAG_ACTIVITY_SINGLE_TOP
            action = OrderNotificationHelper.ACTION_ACCEPT
            putExtra(OrderNotificationHelper.EXTRA_ORDER_ID, orderId)
            putExtra(OrderNotificationHelper.EXTRA_ORDER_DATA, orderDataJson)
        }
        startActivity(launchIntent)
        finish()
    }

    // STOP ALERT: Stop Sound/Vibrate, Close Screen, Keep Notification in Tray
    private fun onStopAlert() {
        Log.d(TAG, "Stop Alert clicked: $orderId")
        stopAlerts()

        // Do NOT dismiss notification (keep it pending in tray)
        // Do NOT send Accept/Reject event. Order remains Pending.

        finish()
    }

    // VIEW DETAIL: Just open the app
    private fun onOpenApp() {
        Log.d(TAG, "View Detail clicked: $orderId")
        stopAlerts()

        // Launch MainActivity
        val launchIntent = Intent(this, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                    Intent.FLAG_ACTIVITY_CLEAR_TOP or
                    Intent.FLAG_ACTIVITY_SINGLE_TOP
            putExtra(OrderNotificationHelper.EXTRA_ORDER_ID, orderId)
            putExtra(OrderNotificationHelper.EXTRA_ORDER_DATA, orderDataJson)
        }
        startActivity(launchIntent)
        finish()
    }

    // REJECT (kept for notification action buttons if needed)
    private fun onReject() {
        Log.d(TAG, "Order rejected: $orderId")

        stopAlerts()

        orderId?.let { OrderNotificationHelper.dismissNotification(this, it) }
        orderId?.let { id ->
            RejectOrderReceiver.onRejectCallback?.invoke(id)
        }

        finish()
    }

    /**
     * Turn on the screen and show over the lock screen.
     */
    private fun turnOnScreen() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
            val keyguardManager = getSystemService(Context.KEYGUARD_SERVICE) as KeyguardManager
            keyguardManager.requestDismissKeyguard(this, null)
        } else {
            @Suppress("DEPRECATION")
            window.addFlags(
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
                WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD or
                WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
            )
        }

        // Acquire a wake lock to ensure the screen stays on
        val pm = getSystemService(Context.POWER_SERVICE) as PowerManager
        wakeLock = pm.newWakeLock(
            PowerManager.FULL_WAKE_LOCK or
            PowerManager.ACQUIRE_CAUSES_WAKEUP or
            PowerManager.ON_AFTER_RELEASE,
            "qmanja:incoming_order"
        )
        wakeLock?.acquire(WAKELOCK_TIMEOUT_MS)
    }

    /**
     * Play ringtone sound and vibrate to alert the store operator.
     */
    private fun startAlerts() {
        try {
            val ringtoneUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_RINGTONE)
            mediaPlayer = MediaPlayer().apply {
                setAudioAttributes(
                    AudioAttributes.Builder()
                        .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                        .setUsage(AudioAttributes.USAGE_ALARM)
                        .build()
                )
                setDataSource(this@IncomingOrderActivity, ringtoneUri)
                isLooping = true
                prepare()
                start()
            }
        } catch (e: Exception) {
            Log.w(TAG, "Failed to play ringtone: $e")
        }

        try {
            vibrator = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                val vm = getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as VibratorManager
                vm.defaultVibrator
            } else {
                @Suppress("DEPRECATION")
                getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
            }

            val pattern = longArrayOf(0, 500, 200, 500, 200, 500)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                vibrator?.vibrate(VibrationEffect.createWaveform(pattern, 0))
            } else {
                @Suppress("DEPRECATION")
                vibrator?.vibrate(pattern, 0)
            }
        } catch (e: Exception) {
            Log.w(TAG, "Failed to vibrate: $e")
        }
    }

    /**
     * Stop ringtone and vibration.
     */
    private fun stopAlerts() {
        try {
            mediaPlayer?.stop()
            mediaPlayer?.release()
        } catch (e: Exception) {
            Log.w(TAG, "Error stopping media player: $e")
        }
        mediaPlayer = null

        try {
            vibrator?.cancel()
        } catch (e: Exception) {
            Log.w(TAG, "Error stopping vibrator: $e")
        }
        vibrator = null
    }

    override fun onDestroy() {
        super.onDestroy()
        stopAlerts()

        try {
            if (wakeLock?.isHeld == true) {
                wakeLock?.release()
            }
        } catch (e: Exception) {
            Log.w(TAG, "Error releasing wake lock: $e")
        }
        wakeLock = null
    }

    /**
     * Prevent accidental back press from dismissing without action.
     */
    @Deprecated("Deprecated in Java")
    override fun onBackPressed() {
        // Do nothing - force user to tap Accept or Stop Alert
    }
}