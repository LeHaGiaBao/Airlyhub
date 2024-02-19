package com.example.batteryandroid;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Bundle;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;

public class MainActivity extends AppCompatActivity {
    private TextView batteryLevelTextView;
    private TextView batteryStateTextView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        batteryLevelTextView = findViewById(R.id.battery_level_text);
        batteryStateTextView = findViewById(R.id.battery_state_text);

        // Register BroadcastReceiver to monitor battery state changes
        IntentFilter filter = new IntentFilter();
        filter.addAction(Intent.ACTION_BATTERY_CHANGED);
        registerReceiver(batteryReceiver, filter);

        // Get initial battery level and state
        updateBatteryInfo();
    }

    // BroadcastReceiver to monitor battery state changes
    private final BroadcastReceiver batteryReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            updateBatteryInfo();
        }
    };

    private void updateBatteryInfo() {
        Intent batteryIntent = registerReceiver(null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
        if (batteryIntent != null) {
            int level = batteryIntent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1);
            int scale = batteryIntent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
            int batteryLevel = (int) ((level / (float) scale) * 100);

            int status = batteryIntent.getIntExtra(BatteryManager.EXTRA_STATUS, -1);
            String batteryStateDescription = getBatteryStateDescription(status);

            // Update UI
            batteryLevelTextView.setText("Battery level: " + batteryLevel + "%");
            batteryStateTextView.setText("Battery state: " + batteryStateDescription);
        }
    }

    private String getBatteryStateDescription(int status) {
        switch (status) {
            case BatteryManager.BATTERY_STATUS_CHARGING:
                return "Charging";
            case BatteryManager.BATTERY_STATUS_DISCHARGING:
                return "On battery power";
            case BatteryManager.BATTERY_STATUS_FULL:
                return "Full charged";
            case BatteryManager.BATTERY_STATUS_UNKNOWN:
            default:
                return "Unknown";
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        unregisterReceiver(batteryReceiver);
    }
}