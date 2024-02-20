import React, { useState, useEffect } from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { NativeModules, NativeEventEmitter } from 'react-native';

const { BatteryModule } = NativeModules;
const batteryEventEmitter = new NativeEventEmitter(BatteryModule);

function App(): React.JSX.Element {
  const [batteryLevel, setBatteryLevel] = useState(null);
  const [batteryState, setBatteryState] = useState(null);
  const [error, setError] = useState(null);

  useEffect(() => {
    const subscriptionLevel = batteryEventEmitter.addListener(
      'BatteryLevel',
      (level) => setBatteryLevel(level)
    );
    const subscriptionState = batteryEventEmitter.addListener(
      'BatteryState',
      (state) => setBatteryState(state)
    );

    // Fetch initial battery level and state
    BatteryModule.getBatteryLevel()
      .then((level: React.SetStateAction<null>) => setBatteryLevel(level))
      .catch((error: React.SetStateAction<null>) => setError(error));

    BatteryModule.getBatteryState()
      .then((state: React.SetStateAction<null>) => setBatteryState(state))
      .catch((error: React.SetStateAction<null>) => setError(error));

    // Clean up subscriptions
    return () => {
      subscriptionLevel.remove();
      subscriptionState.remove();
    };
  }, []);

  return (
    <View style={styles.container}>
      {(batteryLevel !== null && batteryState !== null) && (
        <>
          <Text style={styles.text}>Battery Level: {batteryLevel}%</Text>
          <Text style={styles.text}>Battery State: {batteryState}</Text>
        </>
      )}
      {error && <Text style={styles.errorText}>Error: {error}</Text>}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  text: {
    fontSize: 18,
    marginBottom: 10,
  },
  errorText: {
    fontSize: 18,
    color: 'red',
  },
});

export default App;
