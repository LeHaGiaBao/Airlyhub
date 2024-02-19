package com.batteryreactnative

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Bundle
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity

class MainActivity : AppCompatActivity() {
    private lateinit var batteryLevelTextView: TextView
    private lateinit var batteryStateTextView: TextView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        batteryLevelTextView = findViewById(R.id.battery_level_text)
        batteryStateTextView = findViewById(R.id.battery_state_text)

        // Register BroadcastReceiver to monitor battery state changes
        val filter = IntentFilter(Intent.ACTION_BATTERY_CHANGED)
        registerReceiver(batteryReceiver, filter)

        // Get initial battery level and state
        updateBatteryInfo()
    }

    // BroadcastReceiver to monitor battery state changes
    private val batteryReceiver: BroadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            updateBatteryInfo()
        }
    }

    private fun updateBatteryInfo() {
        val batteryIntent = registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
        batteryIntent?.let {
            val level = it.getIntExtra(BatteryManager.EXTRA_LEVEL, -1)
            val scale = it.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
            val batteryLevel = (level.toFloat() / scale.toFloat() * 100).toInt()

            val status = it.getIntExtra(BatteryManager.EXTRA_STATUS, -1)
            val batteryStateDescription = getBatteryStateDescription(status)

            // Update UI
            batteryLevelTextView.text = "Battery level: $batteryLevel%"
            batteryStateTextView.text = "Battery state: $batteryStateDescription"
        }
    }

    private fun getBatteryStateDescription(status: Int): String {
        return when (status) {
            BatteryManager.BATTERY_STATUS_CHARGING -> "Charging"
            BatteryManager.BATTERY_STATUS_DISCHARGING -> "On battery power"
            BatteryManager.BATTERY_STATUS_FULL -> "Full charged"
            else -> "Unknown"
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        unregisterReceiver(batteryReceiver)
    }
}
