<p align="center">
  <h1 align="center"> <code>battery_info</code> </h1>
</p>

本项目基于 [battery_info](https://github.com/igrik12/battery_info)开发

## 1. 安装与使用

### 1.1 安装方式

进入到工程目录并在 pubspec.yaml 中添加以下依赖：


#### pubspec.yaml
##### url使用方式 
```yaml
...

dependencies:
  battery_info:
    git:
      url: https://gitcode.com/OpenHarmony-Flutter/fluttertpc_battery_info.git

...
```

执行命令

```bash
flutter pub get
```

### 1.2 使用案例

使用案例详见 [example](example/lib/main.dart)

## 2. 约束与限制

### 2.1 兼容性

已在以下环境验证：

1. Flutter: 3.7.12-ohos-1.1.3; SDK: 5.0.0(12); IDE: DevEco Studio: 6.0.2.640; ROM: 6.0.0.130 SP18;
2. Flutter: 3.22.1-ohos-1.1.0; SDK: 5.0.0(12); IDE: DevEco Studio: 6.0.2.640; ROM: 6.0.0.130 SP18;
3. Flutter: 3.27.5-ohos-1.0.4; SDK: 5.0.0(12); IDE: DevEco Studio: 6.0.2.640; ROM: 6.0.0.130 SP18;

## 3. 版本和框架对应关系

|       | 3.7 | 3.22 | 3.27 |
|-------|:---:|:----:|:----:|
| 1.0.0 |  ✅  |  ✅   |  ✅   |

## 4. API

> [!TIP] "ohos Support"列为 yes 表示 ohos 平台支持该属性；no 则表示不支持；partially 表示部分支持。使用方法跨平台一致，效果对标 iOS 或 Android 的效果


| 名称 | 说明 | 类型 | 输入 | 输出 | ohos Support |
|------|------|------|------|------|--------------|
| androidBatteryInfo | 单次获取 Android 风格电池信息（电量、健康、充电状态、电流、电压、温度等） | getter | 无 | `Future<AndroidBatteryInfo?>` | yes |
| androidBatteryInfoStream | 订阅 Android 风格电池信息流，持续接收更新 | getter | 无 | `Stream<AndroidBatteryInfo?>` | yes |
| iosBatteryInfo | 单次获取 iOS 风格电池信息（电量、充电状态） | getter | 无 | `Future<IosBatteryInfo?>` | yes |
| iosBatteryInfoStream | 订阅 iOS 风格电池信息流，持续接收更新 | getter | 无 | `Stream<IosBatteryInfo?>` | yes |


## 5. 遗留问题

无

## 6. 开源协议

本项目基于 [MIT License](LICENSE)，请自由地享受和参与开源。
