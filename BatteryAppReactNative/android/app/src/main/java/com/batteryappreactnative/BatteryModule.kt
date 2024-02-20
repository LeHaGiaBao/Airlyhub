package com.batteryappreactnative

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import com.facebook.react.bridge.*
import com.facebook.react.modules.core.DeviceEventManagerModule

class BatteryModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {
    private var batteryLevel = -1
    private var batteryState = "Unknown"

    private val batteryReceiver: BroadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            updateBatteryInfo()
        }
    }

    override fun getName(): String {
        return "BatteryModule"
    }

    override fun initialize() {
        super.initialize()
        val filter = IntentFilter(Intent.ACTION_BATTERY_CHANGED)
        reactApplicationContext.registerReceiver(batteryReceiver, filter)
        updateBatteryInfo()
    }

    override fun onCatalystInstanceDestroy() {
        super.onCatalystInstanceDestroy()
        reactApplicationContext.unregisterReceiver(batteryReceiver)
    }

    private fun updateBatteryInfo() {
        val batteryIntent = reactApplicationContext.registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
        batteryIntent?.let {
            val level = it.getIntExtra(BatteryManager.EXTRA_LEVEL, -1)
            val scale = it.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
            batteryLevel = (level.toFloat() / scale.toFloat() * 100).toInt()

            val status = it.getIntExtra(BatteryManager.EXTRA_STATUS, -1)
            batteryState = getBatteryStateDescription(status)

            sendEvent("BatteryLevel", batteryLevel)
            sendEvent("BatteryState", batteryState)
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

    private fun sendEvent(eventName: String, data: Any) {
        reactApplicationContext
            .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
            .emit(eventName, data)
    }

    @ReactMethod
    fun getBatteryLevel(promise: Promise) {
        promise.resolve(batteryLevel)
    }

    @ReactMethod
    fun getBatteryState(promise: Promise) {
        promise.resolve(batteryState)
    }
}
