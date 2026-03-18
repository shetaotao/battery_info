<p align="center">
  <h1 align="center"> <code>battery_info</code> </h1>
</p>

This project is based on [battery_info](https://github.com/igrik12/battery_info).

## 1. Installation and Usage

### 1.1 Installation

Navigate to your project directory and add the following dependency to `pubspec.yaml`:

#### pubspec.yaml

##### Git URL

```yaml
...

dependencies:
  battery_info:
    git:
      url: https://gitcode.com/OpenHarmony-Flutter/fluttertpc_battery_info.git

...
```

Then run:

```bash
flutter pub get
```

### 1.2 Example

See [example](example/lib/main.dart) for usage examples.

## 2. Constraints and Limitations

### 2.1 Compatibility

Verified in the following environments:

1. Flutter: 3.7.12-ohos-1.1.3; SDK: 5.0.0(12); IDE: DevEco Studio: 6.0.2.640; ROM: 6.0.0.130 SP18;
2. Flutter: 3.22.1-ohos-1.1.0; SDK: 5.0.0(12); IDE: DevEco Studio: 6.0.2.640; ROM: 6.0.0.130 SP18;
3. Flutter: 3.27.5-ohos-1.0.4; SDK: 5.0.0(12); IDE: DevEco Studio: 6.0.2.640; ROM: 6.0.0.130 SP18;

## 3. Version and Framework Compatibility

|       | 3.7 | 3.22 | 3.27 |
|-------|:---:|:----:|:----:|
| 1.0.0 |  ✅  |  ✅   |  ✅   |

## 4. API

> [!TIP] "ohos Support" = yes means the API is supported on OHOS; no means not supported; partially means partial support. Usage is consistent across platforms, with behavior aligned to iOS or Android.

| Name | Description | Type | Input | Output | ohos Support |
|------|-------------|------|-------|--------|--------------|
| androidBatteryInfo | Get Android-style battery info once (level, health, charging status, current, voltage, temperature, etc.) | getter | none | `Future<AndroidBatteryInfo?>` | yes |
| androidBatteryInfoStream | Subscribe to Android-style battery info stream for continuous updates | getter | none | `Stream<AndroidBatteryInfo?>` | yes |
| iosBatteryInfo | Get iOS-style battery info once (level, charging status) | getter | none | `Future<IosBatteryInfo?>` | yes |
| iosBatteryInfoStream | Subscribe to iOS-style battery info stream for continuous updates | getter | none | `Stream<IosBatteryInfo?>` | yes |

**Usage recommendation**: On Android / OHOS, prefer `androidBatteryInfo` and `androidBatteryInfoStream` for full fields; on iOS, prefer `iosBatteryInfo` and `iosBatteryInfoStream`; for cross-platform apps that only need level and charging status, use `IosBatteryInfo` or read only `batteryLevel` and `chargingStatus`.

## 5. Known Issues

None

## 6. License

This project is licensed under [MIT License](LICENSE). Feel free to use and contribute.
