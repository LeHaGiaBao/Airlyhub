import React, { useState, useEffect } from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { NativeModules } from 'react-native';

const BatteryModule = NativeModules.BatteryModule;

function App() {
  const [batteryLevel, setBatteryLevel] = useState(null);
  const [batteryState, setBatteryState] = useState(null)
  const [error, setError] = useState(null);

  useEffect(() => {
    BatteryModule.getBatteryInfo()
      .then((batteryInfo: React.SetStateAction<null>) => {
        setBatteryLevel(batteryInfo)
        setBatteryState(batteryInfo)
      })
      .catch((error: React.SetStateAction<null>) => {
        setError(error);
      });
  }, []);

  return (
    <View style={styles.container}>
      {(batteryLevel && batteryState) && (
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
