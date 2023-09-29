import 'dart:async';

import 'package:example/components/text.dart';
import 'package:example/main.dart';
import 'package:example/utils.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class AccelerometerScreen extends StatefulWidget {
  const AccelerometerScreen({super.key});

  @override
  State<AccelerometerScreen> createState() => _AccelerometerScreenState();
}

class _AccelerometerScreenState extends State<AccelerometerScreen> {
  late StreamSubscription _streamSubscription;
  final ValueNotifier<({double x, double y, double z})?> _accelData = ValueNotifier(null);

  @override
  void initState() {
    super.initState();

    _streamSubscription = accelerometerEvents.listen((e) {
      _accelData.value = (x: e.x, y: e.y, z: e.z);
    });
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextATV.carouselHeading('Accelerometer'.toUpperCase()),
      ),
      body: Center(
        child: ValueListenableBuilder(
            valueListenable: _accelData,
            builder: (context, data, _) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(data?.x.roundToDecimals(2).toString() ?? "100", style: dataTextStyle),
                    Text(data?.y.roundToDecimals(2).toString() ?? "100", style: dataTextStyle),
                    Text(data?.z.roundToDecimals(2).toString() ?? "100", style: dataTextStyle),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
