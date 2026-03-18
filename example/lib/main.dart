import 'package:flutter/material.dart';
import 'package:battery_info/battery_info_plugin.dart';
import 'package:battery_info/model/android_battery_info.dart';
import 'package:battery_info/enums/charging_status.dart';

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder<AndroidBatteryInfo?>(
                  future: BatteryInfoPlugin().androidBatteryInfo,
                  builder: (context, snapshot) {
                    final data = snapshot.data;
                    if (snapshot.hasData && data != null) {
                      return Text(
                          'Battery Health: ${data.health?.toUpperCase() ?? "N/A"}');
                    }
                    return CircularProgressIndicator();
                  }),
              SizedBox(
                height: 20,
              ),
              StreamBuilder<AndroidBatteryInfo?>(
                  stream: BatteryInfoPlugin().androidBatteryInfoStream,
                  builder: (context, snapshot) {
                    final data = snapshot.data;
                    if (snapshot.hasData && data != null) {
                      return Column(
                        children: [
                          Text("Voltage: ${data.voltage ?? "N/A"} mV"),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                              "Charging status: ${data.chargingStatus?.toString().split(".").last ?? "N/A"}"),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                              "Battery Level: ${data.batteryLevel ?? "N/A"} %"),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                              "Battery Capacity: ${data.batteryCapacity != null ? (data.batteryCapacity! / 1000) : "N/A"} mAh"),
                          SizedBox(
                            height: 20,
                          ),
                          Text("Technology: ${data.technology ?? "N/A"} "),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                              "Battery present: ${data.present == true ? "Yes" : "False"} "),
                          SizedBox(
                            height: 20,
                          ),
                          Text("Scale: ${data.scale ?? "N/A"} "),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                              "Remaining energy: ${data.remainingEnergy != null ? -(data.remainingEnergy! * 1.0E-9) : "N/A"} Watt-hours,"),
                          SizedBox(
                            height: 20,
                          ),
                          _getChargeTime(data),
                        ],
                      );
                    }
                    return CircularProgressIndicator();
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget _getChargeTime(AndroidBatteryInfo data) {
    if (data.chargingStatus == ChargingStatus.Charging) {
      final remaining = data.chargeTimeRemaining;
      return remaining == null || remaining == -1
          ? Text("Charge time remaining: N/A minutes")
          : Text(
              "Charge time remaining: ${(remaining / 1000 / 60).truncate()} minutes");
    }
    return Text("Battery is full or not connected to a power source");
  }
}
