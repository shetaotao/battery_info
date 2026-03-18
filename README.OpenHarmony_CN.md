# battery_info

本项目基于 [battery_info](https://pub.dev/packages/battery_info) 开发。

## 简介

battery_info 是一个 Flutter 插件，用于获取设备电池的详细信息，包括电量、健康状态、充电状态、电流、电压、温度等。该插件支持 Android、iOS 和 OpenHarmony 平台。<br/>

## 下载安装

进入到工程目录并在 pubspec.yaml 中添加以下依赖：

```yaml
dependencies:
  battery_info:
    git:
      url: https://gitcode.com/OpenHarmony-Flutter/fluttertpc_battery_info.git
      ref: 1.1.1-ohos-1.0.0
```

执行命令

```bash
flutter pub get
```

> TAG 命名规则：`原库版本-ohos-版本号-betax`，不同 TAG 之间的变更详见 CHANGELOG.md。

| Flutter 框架版本 | TAG 名称 | 备注 |
| ---------------- | -------- | ---- |
| 3.7  | 1.1.1-ohos-1.0.0 |      |
| 3.22 | 1.1.1-ohos-1.0.0 |      |
| 3.27 | 1.1.1-ohos-1.0.0 |      |

## 约束与限制

### 兼容性

在以下版本中已测试通过：

1. Flutter: 3.7.12-ohos-1.1.3; SDK: 5.0.0(12); IDE: DevEco Studio: 6.1.0.830; ROM: 6.0.0.130 SP25;
2. Flutter: 3.22.1-ohos-1.1.0; SDK: 5.0.0(12); IDE: DevEco Studio: 6.1.0.830; ROM: 6.0.0.130 SP25;
3. Flutter: 3.27.5-ohos-1.0.4; SDK: 5.0.0(12); IDE: DevEco Studio: 6.1.0.830; ROM: 6.0.0.130 SP25;

### 权限要求

无

## 使用示例

使用案例详见 [example](example/lib/main.dart)

以下是一个简单的使用示例：

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

## 接口说明

> [!TIP] "OHOS 平台支持"列为 yes 表示 ohos 平台支持该属性，no 则表示不支持。使用方法跨平台一致，效果对标 iOS 或 Android 的效果。

### API

| 名称 | 类型 | 参数类型 | 返回值 | OHOS 平台支持 | 描述 |
|------|------|----------|--------|---------------|------|
| androidBatteryInfo() | 方法 | 无 | `Future<AndroidBatteryInfo?>` | yes | 单次获取 Android 风格电池信息（电量、健康、充电状态、电流、电压、温度等） |
| androidBatteryInfoStream() | 方法 | 无 | `Stream<AndroidBatteryInfo?>` | yes | 订阅 Android 风格电池信息流，持续接收更新 |
| iosBatteryInfo() | 方法 | 无 | `Future<IosBatteryInfo?>` | yes | 单次获取 iOS 风格电池信息（电量、充电状态） |
| iosBatteryInfoStream() | 方法 | 无 | `Stream<IosBatteryInfo?>` | yes | 订阅 iOS 风格电池信息流，持续接收更新 |

**使用建议**：在 Android / OpenHarmony 平台，推荐使用 `androidBatteryInfo` 和 `androidBatteryInfoStream` 获取完整的电池信息字段；在 iOS 平台，推荐使用 `iosBatteryInfo` 和 `iosBatteryInfoStream`；对于只需要电量和充电状态的跨平台应用，可以使用 `IosBatteryInfo` 或仅读取 `batteryLevel` 和 `chargingStatus`。

### AndroidBatteryInfo 数据模型

| 字段 | 类型 | 说明 |
|------|------|------|
| batteryLevel | int? | 电池电量百分比 |
| batteryCapacity | int? | 电池容量（mAh）|
| chargingStatus | ChargingStatus? | 充电状态（Charging/Discharging/Full/Unknown）|
| chargeTimeRemaining | int? | 充满剩余时间（毫秒）|
| currentNow | int? | 当前电流（微安）|
| currentAverage | int? | 平均电流（微安）|
| health | String? | 电池健康状态 |
| pluggedStatus | String? | 电源连接状态 |
| present | bool? | 电池是否存在 |
| remainingEnergy | int? | 剩余能量 |
| scale | int? | 电量刻度 |
| temperature | int? | 电池温度 |
| technology | String? | 电池技术类型 |
| voltage | int? | 电池电压（毫伏）|

### IosBatteryInfo 数据模型

| 字段 | 类型 | 说明 |
|------|------|------|
| batteryLevel | int? | 电池电量百分比 |
| chargingStatus | ChargingStatus? | 充电状态（Charging/Discharging/Full/Unknown）|

## 遗留问题
无

## 其他
无

## 目录结构

```
|---- battery_info
|     |---- android              # Android 适配代码
|     |---- example              # 示例应用
|           |---- lib            # 示例代码
|           |---- ohos           # OpenHarmony 工程
|     |---- ios                  # iOS 适配代码
|     |---- lib                  # 核心代码实现
|           |---- enums          # 枚举定义
|           |---- model          # 数据模型
|           |---- battery_info_plugin.dart  # 插件主入口
|     |---- ohos                 # OpenHarmony 适配代码
|     |---- test                 # 单元测试文件
|     |---- CHANGELOG.md         # 更新日志
|     |---- LICENSE              # 开源协议
|     |---- README.md            # 英文说明文档
|     |---- README.OpenHarmony_CN.md  # 中文说明文档
|     |---- README.OpenHarmony.md     # 英文说明文档（OpenHarmony）
|     |---- pubspec.yaml         # 配置文件
```

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitcode.com/OpenHarmony-Flutter/fluttertpc_battery_info/issues)，当然，也非常欢迎发 [PR](https://gitcode.com/OpenHarmony-Flutter/fluttertpc_battery_info/pulls) 共建。


## 开源协议

本项目基于 [MIT License](LICENSE)，请自由地享受和参与开源。
