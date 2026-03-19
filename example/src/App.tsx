import { Text, View, StyleSheet } from 'react-native';
import { SberModule, SID_STAND } from 'react-native-nitro-sber';
import { useEffect, useState } from 'react';

export default function App() {
  const [status, setStatus] = useState('idle');

  useEffect(() => {
    let cancelled = false;
    (async () => {
      try {
        setStatus('initializing');
        await SberModule.initialize(
          'clientId',
          undefined,
          undefined,
          '#ffffff',
          '#000000',
          undefined,
          undefined,
          SID_STAND.PROM_STAND
        );
        if (!cancelled) setStatus('ready');
      } catch (e) {
        if (!cancelled) setStatus(`error: ${String(e)}`);
      }
    })();
    return () => {
      cancelled = true;
    };
  }, []);

  return (
    <View style={styles.container}>
      <Text>Status: {status}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
