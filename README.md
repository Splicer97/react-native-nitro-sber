# react-native-nitro-sber

123

## Installation


```sh
npm install react-native-nitro-sber react-native-nitro-modules

> `react-native-nitro-modules` is required as this library relies on [Nitro Modules](https://nitro.margelo.com/).
```

### Android: SberID SDK

This library bundles the SberID Android SDK dependency.

- **Dependency**: `io.github.sid-sdk:SIDSDK_CORE`
- **Default version**: `1.1.3`
- **Override version**: in your app's `android/build.gradle`, set:

```gradle
ext.sidSdkCoreVersion = "1.1.3"
```


## Usage


```js
import { SberModule } from 'react-native-nitro-sber';

// ...

await SberModule.initialize(
  'clientId',
  undefined,
  undefined,
  '#ffffff',
  '#000000',
  undefined,
  undefined,
  undefined
);
```


## Contributing

- [Development workflow](CONTRIBUTING.md#development-workflow)
- [Sending a pull request](CONTRIBUTING.md#sending-a-pull-request)
- [Code of conduct](CODE_OF_CONDUCT.md)

## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
