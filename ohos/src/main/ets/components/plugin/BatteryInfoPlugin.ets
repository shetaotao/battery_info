import {
  FlutterPlugin,
  FlutterPluginBinding,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult,
  EventChannel,
  StreamHandler,
  EventSink,
  Log,
} from '@ohos/flutter_ohos';

// 电池信息接口：参考 https://developer.huawei.com/consumer/cn/doc/harmonyos-references/js-apis-battery-info
// @ohos.batteryInfo：batterySOC | chargingStatus | healthStatus | pluggedType | voltage | technology | batteryTemperature | isBatteryPresent | batteryCapacityLevel | nowCurrent
import batteryInfo from '@ohos.batteryInfo';

const STREAM_INTERVAL_MS = 2000;
const TAG = "BatteryInfoPlugin";

export default class BatteryInfoPlugin implements FlutterPlugin, MethodCallHandler, StreamHandler {
  private channel: MethodChannel | null = null;
  private streamChannel: EventChannel | null = null;
  private streamTimerId: number = -1;
  private eventSink: EventSink | null = null;

  getUniqueClassName(): string {
    return "BatteryInfoPlugin";
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.channel = new MethodChannel(binding.getBinaryMessenger(), "com.igrik12.battery_info/channel");
    this.channel.setMethodCallHandler(this);
    this.streamChannel = new EventChannel(binding.getBinaryMessenger(), "com.igrik12.battery_info/stream");
    this.streamChannel.setStreamHandler(this);
  }

  onDetachedFromEngine(_binding: FlutterPluginBinding): void {
    this.stopBatteryStream();
    if (this.channel != null) {
      this.channel.setMethodCallHandler(null);
      this.channel = null;
    }
    if (this.streamChannel != null) {
      this.streamChannel.setStreamHandler(null);
      this.streamChannel = null;
    }
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    if (call.method == "getBatteryInfo") {
      try {
        const map = this.buildBatteryInfoMap();
        result.success(map);
      } catch (e) {
        result.error("BatteryError", (e as Error).message ?? "getBatteryInfo failed", null);
      }
    } else {
      result.notImplemented();
    }
  }

  // ---------- StreamHandler ----------
  onListen(_args: Object, events: EventSink): void {
    this.eventSink = events;
    this.eventSink.success(this.buildBatteryInfoMap());
    this.streamTimerId = setInterval(() => {
      if (this.eventSink != null) {
        try {
          this.eventSink.success(this.buildBatteryInfoMap());
        } catch (e) {
          Log.e(TAG, "batteryInfoStream push failed", (e as Error).message ?? String(e));
        }
      }
    }, STREAM_INTERVAL_MS);
  }

  onCancel(_args: Object): void {
    this.stopBatteryStream();
  }

  private stopBatteryStream(): void {
    if (this.streamTimerId >= 0) {
      clearInterval(this.streamTimerId);
      this.streamTimerId = -1;
    }
    this.eventSink = null;
  }

  /**
   * 构建Map，供 Dart AndroidBatteryInfo.fromJson 解析。
   */
  private buildBatteryInfoMap(): Record<string, Object | number | string | boolean | null> {
    const rawCharge = batteryInfo.chargingStatus;
    const numVal = Number(rawCharge);
    const chargingStatus = this.mapChargingStatus(
      Number.isFinite(numVal) && numVal >= 0 && numVal <= 3 ? numVal : String(rawCharge)
    );
    const health = this.mapHealthStatus(Number(batteryInfo.healthStatus));
    const pluggedStatus = this.mapPluggedType(Number(batteryInfo.pluggedType));

    // voltage：官方文档单位为微伏(μV)，转换为毫伏(mV)，故除以 1000
    const voltageUv = batteryInfo.voltage ?? 0;
    const voltageMv = voltageUv > 0 ? Math.floor(voltageUv / 1000) : -1;

    // batteryTemperature：官方文档单位 0.1°C
    const temperature = (batteryInfo.batteryTemperature !== undefined && batteryInfo.batteryTemperature !== null)
      ? batteryInfo.batteryTemperature
      : -1;

    // technology：官方文档为 string 类型
    const technology = (batteryInfo.technology !== undefined && batteryInfo.technology !== null)
      ? String(batteryInfo.technology)
      : "unknown";

    // nowCurrent：单位 mA
    const currentNow = batteryInfo.nowCurrent ?? -1;

    const isBatteryPresent = batteryInfo.isBatteryPresent ?? false;

    const batteryCapacityLevel = batteryInfo.batteryCapacityLevel ?? -1;

    const batterySOC = batteryInfo.batterySOC ?? -1;
    return {
      "batteryLevel": batterySOC,
      "batterySOC": batterySOC,
      "batteryCapacity": -1,
      "batteryCapacityLevel": batteryCapacityLevel,
      "chargeTimeRemaining": null,
      "chargingStatus": chargingStatus,
      "health": health,
      "healthStatus": health,
      "pluggedStatus": pluggedStatus,
      "pluggedType": pluggedStatus,
      "voltage": voltageMv,
      "technology": technology,
      "temperature": temperature,
      "batteryTemperature": temperature,
      "present": isBatteryPresent,
      "isBatteryPresent": isBatteryPresent,
      "currentNow": currentNow,
      "currentAverage": currentNow, // 鸿蒙无平均电流 API，用 nowCurrent 代替
      "remainingEnergy": -1,
      "scale": 100, // 电量最大刻度常量，batterySOC 为 0–100
    };
  }


  // 官方文档 BatteryChargeState：NONE=0, ENABLE=1, DISABLE=2, FULL=3（枚举可能为数字或字符串）
  private mapChargingStatus(status: number | string): string {
    if (typeof status === 'number') {
      if (!Number.isFinite(status)) {
        return "unknown";
      }
      switch (status) {
        case 0:
          return "discharging";
        case 1:
          return "charging";
        case 2:
          return "discharging";
        case 3:
          return "full";
        default:
          return "unknown";
      }
    }
    const str = String(status).trim().toUpperCase();
    if (str === 'ENABLE' || str === '1') {
      return "charging";
    }
    if (str === 'DISABLE' || str === '2') {
      return "discharging";
    }
    if (str === 'FULL' || str === '3') {
      return "full";
    }
    if (str === 'NONE' || str === '0') {
      return "discharging";
    }
    return "unknown";
  }

  // 官方文档 BatteryHealthState：UNKNOWN=0, GOOD=1, OVERHEAT=2, OVERVOLTAGE=3, COLD=4, DEAD=5
  private mapHealthStatus(status: number): string {
    switch (status) {
      case 1:
        return "health_good";
      case 2:
        return "over_heat";
      case 3:
        return "over_voltage";
      case 4:
        return "cold";
      case 5:
        return "dead";
      case 6:
        return "unspecified_failure";
      default:
        return "unknown";
    }
  }

  // 官方文档 BatteryPluggedType：NONE=0, AC=1, USB=2, WIRELESS=3
  private mapPluggedType(plugged: number): string {
    switch (plugged) {
      case 1:
        return "AC";
      case 2:
        return "USB";
      case 3:
        return "wireless";
      default:
        return "unknown";
    }
  }
}
