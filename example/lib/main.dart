import 'package:flutter/material.dart';
import 'package:battery_info/battery_info_plugin.dart';
import 'package:battery_info/model/android_battery_info.dart';
import 'package:battery_info/model/iso_battery_info.dart';
import 'package:battery_info/model/ohos_battery_info.dart';
import 'package:battery_info/enums/charging_status.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Battery Info plugin example'),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Android Battery Info'),
              Tab(text: 'OHOS Battery Info'),
              Tab(text: 'iOS Battery Info'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildAndroidTab(),
            _buildOhosTab(),
            _buildIosTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildAndroidTab() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'androidBatteryInfo:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
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
            Text(
              'androidBatteryInfoStream:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
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
                        Text("Battery Level: ${data.batteryLevel ?? "N/A"} %"),
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
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildOhosTab() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ohosBatteryInfo:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            FutureBuilder<OhosBatteryInfo?>(
                future: BatteryInfoPlugin().ohosBatteryInfo,
                builder: (context, snapshot) {
                  final data = snapshot.data;
                  if (snapshot.hasData && data != null) {
                    return Text(
                        'Battery Health: ${data.health?.toUpperCase() ?? "N/A"}');
                  }
                  return CircularProgressIndicator();
                }),
            SizedBox(height: 20),
            Text(
              'ohosBatteryInfoStream:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            StreamBuilder<OhosBatteryInfo?>(
                stream: BatteryInfoPlugin().ohosBatteryInfoStream,
                builder: (context, snapshot) {
                  final data = snapshot.data;
                  if (snapshot.hasData && data != null) {
                    return Column(
                      children: [
                        Text("Voltage: ${data.voltage ?? "N/A"} mV"),
                        SizedBox(height: 20),
                        Text(
                            "Charging status: ${data.chargingStatus?.toString().split(".").last ?? "N/A"}"),
                        SizedBox(height: 20),
                        Text("Battery Level: ${data.batteryLevel ?? "N/A"} %"),
                        SizedBox(height: 20),
                        Text(
                            "Battery Capacity: ${data.batteryCapacity != null ? (data.batteryCapacity! / 1000) : "N/A"} mAh"),
                        SizedBox(height: 20),
                        Text("Technology: ${data.technology ?? "N/A"} "),
                        SizedBox(height: 20),
                        Text(
                            "Battery present: ${data.present == true ? "Yes" : "False"} "),
                        SizedBox(height: 20),
                        Text("Scale: ${data.scale ?? "N/A"} "),
                        SizedBox(height: 20),
                        Text(
                            "Remaining energy: ${data.remainingEnergy != null ? -(data.remainingEnergy! * 1.0E-9) : "N/A"} Watt-hours,"),
                        SizedBox(height: 20),
                        _getOhosChargeTime(data),
                      ],
                    );
                  }
                  return CircularProgressIndicator();
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildIosTab() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'iosBatteryInfo:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            FutureBuilder<IosBatteryInfo?>(
                future: BatteryInfoPlugin().iosBatteryInfo,
                builder: (context, snapshot) {
                  final data = snapshot.data;
                  if (snapshot.hasData && data != null) {
                    return Text(
                        'Battery Level: ${data.batteryLevel ?? "N/A"} %');
                  }
                  return CircularProgressIndicator();
                }),
            SizedBox(
              height: 20,
            ),
            Text(
              'iosBatteryInfoStream:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            StreamBuilder<IosBatteryInfo?>(
                stream: BatteryInfoPlugin().iosBatteryInfoStream,
                builder: (context, snapshot) {
                  final data = snapshot.data;
                  if (snapshot.hasData && data != null) {
                    return Column(
                      children: [
                        Text("Battery Level: ${data.batteryLevel ?? "N/A"} %"),
                      ],
                    );
                  }
                  return CircularProgressIndicator();
                }),
          ],
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

  Widget _getOhosChargeTime(OhosBatteryInfo data) {
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
