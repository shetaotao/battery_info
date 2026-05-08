> Document Template: v0.4.1, [Document Specification](./Document_Specification.md)(delete)
# battery_info

This project is based on [battery_info](https://pub.dev/packages/battery_info).

## Introduction

battery_info is a Flutter plugin for retrieving detailed battery information from the device, including battery level, health status, charging status, current, voltage, temperature, etc. This plugin supports Android, iOS, and OpenHarmony platforms.<br/>

## Installation

Navigate to your project directory and add the following dependency to your pubspec.yaml:

```yaml
dependencies:
  battery_info:
    git:
      url: https://gitcode.com/OpenHarmony-Flutter/fluttertpc_battery_info.git
      ref: 1.1.1-ohos-1.0.0
```

Execute the command:

```bash
flutter pub get
```

> TAG Naming Convention: `original-version-ohos-version-betax`. 

| Flutter Framework Version | TAG Name |
| ---------------- | ----------------------- |
| 3.7.12-ohos-1.1.3 | 1.1.1-ohos-1.0.0 |
| 3.22.1-ohos-1.1.0 | 1.1.1-ohos-1.0.0 |
| 3.27.5-ohos-1.0.4 | 1.1.1-ohos-1.0.0 |
| 3.35.8-ohos-0.0.2 | 1.1.1-ohos-1.0.0 |

## Constraints and Limitations

### Compatibility

Tested and verified on the following versions:

1. Flutter: 3.7.12-ohos-1.1.3; SDK: 5.0.0(12); IDE: DevEco Studio: 6.1.0.830; ROM: 6.1.0.117 SP6;
2. Flutter: 3.22.1-ohos-1.1.0; SDK: 5.0.0(12); IDE: DevEco Studio: 6.1.0.830; ROM: 6.1.0.117 SP6;
3. Flutter: 3.27.5-ohos-1.0.4; SDK: 5.0.0(12); IDE: DevEco Studio: 6.1.0.830; ROM: 6.1.0.117 SP6;
4. Flutter: 3.35.8-ohos-0.0.2; SDK: 5.0.0(12); IDE: DevEco Studio: 6.1.0.830; ROM: 6.1.0.117 SP6; 

### Permission Requirements

None

## Usage Example

For usage examples, please refer to [example](example/lib/main.dart)<br/>

Here is a simple usage example:<br/>

```dart
import 'package:flutter/material.dart';
import 'package:battery_info/battery_info_plugin.dart';
import 'package:battery_info/model/android_battery_info.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Battery Info plugin example'),
        ),
        body: Center(
          child: StreamBuilder<AndroidBatteryInfo?>(
            stream: BatteryInfoPlugin().androidBatteryInfoStream,
            builder: (context, snapshot) {
              final data = snapshot.data;
              if (snapshot.hasData && data != null) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Battery Level: ${data.batteryLevel ?? 'N/A'} %"),
                    Text("Charging status: ${data.chargingStatus?.toString().split('.').last ?? 'N/A'}"),
                    Text("Voltage: ${data.voltage ?? 'N/A'} mV"),
                    Text("Temperature: ${data.temperature ?? 'N/A'}"),
                  ],
                );
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
```

## API Reference

### API

> [!TIP] The "ohos Support" column indicates whether the ohos platform supports the property (yes) or not (no). The usage method is consistent across platforms, with effects matching iOS or Android.

| Name | Type | Parameter Type | Return Value | OHOS Platform Support | Description |
|------|------|----------------|--------------|----------------------|-------------|
| androidBatteryInfo | getter | none | `Future<AndroidBatteryInfo?>` | yes | Get Android-style battery information once (level, health, charging status, current, voltage, temperature, etc.) |
| androidBatteryInfoStream | getter | none | `Stream<AndroidBatteryInfo?>` | yes | Subscribe to Android-style battery information stream for continuous updates |
| iosBatteryInfo | getter | none | `Future<IosBatteryInfo?>` | yes | Get iOS-style battery information once (level, charging status) |
| iosBatteryInfoStream | getter | none | `Stream<IosBatteryInfo?>` | yes | Subscribe to iOS-style battery information stream for continuous updates |

**Usage Recommendation**: On Android / OpenHarmony platforms, it is recommended to use `androidBatteryInfo` and `androidBatteryInfoStream` to get complete battery information fields; on iOS platform, it is recommended to use `iosBatteryInfo` and `iosBatteryInfoStream`; for cross-platform apps that only need battery level and charging status, you can use `IosBatteryInfo` or simply read `batteryLevel` and `chargingStatus`.

### AndroidBatteryInfo Data Model

| Field | Type | Description |
|-------|------|-------------|
| batteryLevel | int? | Battery level percentage |
| batteryCapacity | int? | Battery capacity (mAh) |
| chargingStatus | ChargingStatus? | Charging status (Charging/Discharging/Full/Unknown) |
| chargeTimeRemaining | int? | Time remaining to full charge (milliseconds) |
| currentNow | int? | Current now (microamperes) |
| currentAverage | int? | Average current (microamperes) |
| health | String? | Battery health status |
| pluggedStatus | String? | Power connection status |
| present | bool? | Whether battery is present |
| remainingEnergy | int? | Remaining energy |
| scale | int? | Battery scale |
| temperature | int? | Battery temperature |
| technology | String? | Battery technology type |
| voltage | int? | Battery voltage (millivolts) |

### IosBatteryInfo Data Model

| Field | Type | Description |
|-------|------|-------------|
| batteryLevel | int? | Battery level percentage |
| chargingStatus | ChargingStatus? | Charging status (Charging/Discharging/Full/Unknown) |

## Known Issues
None

## Others
None

## Directory Structure

```
|---- android              # Android adapter code
|---- example              # Example application
|      |---- lib            # Example code
|      |---- ohos           # OpenHarmony project
|---- ios                  # iOS adapter code
|---- lib                  # Core code implementation
|      |---- enums          # Enum definitions
|      |---- model          # Data models
|      |---- battery_info_plugin.dart  # Plugin main entry
|---- ohos                 # OpenHarmony adapter code
|---- test                 # Unit test files
|---- CHANGELOG.md         # Changelog
|---- LICENSE              # Open source license
|---- README.md            # English documentation
|---- README.OpenHarmony_CN.md  # Chinese documentation
|---- README.OpenHarmony.md     # English documentation (OpenHarmony)
|---- pubspec.yaml         # Configuration file
```

## Contributing

If you encounter any issues during usage, please submit an [Issue](https://gitcode.com/OpenHarmony-Flutter/fluttertpc_battery_info/issues). Of course, [PRs](https://gitcode.com/OpenHarmony-Flutter/fluttertpc_battery_info/pulls) are also very welcome.

## License

This project is licensed under the [MIT License](LICENSE). Please feel free to enjoy and participate in open source.
