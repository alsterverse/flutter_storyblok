import 'dart:math';

import 'package:example/components/colors.dart';
import 'package:flutter/material.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  static final randomSeed = Random();

  static final _colors = [
    AppColors.primary.withOpacity(.1),
    AppColors.primary.withOpacity(.1),
    AppColors.primary.withOpacity(.1),
    AppColors.primary.withOpacity(.1),
    AppColors.primary.withOpacity(.1),
    AppColors.primary.withOpacity(.1),
    AppColors.primary.withOpacity(.1),
  ];

  static final _durations = [
    randomSeed.nextInt(2000) + 4000,
    randomSeed.nextInt(2000) + 5000,
    randomSeed.nextInt(2000) + 6000,
    randomSeed.nextInt(2000) + 7000,
    randomSeed.nextInt(2000) + 8000,
    randomSeed.nextInt(2000) + 9000,
    randomSeed.nextInt(2000) + 10000,
  ];

  static final _heightPercentages = [
    (randomSeed.nextInt(20) + 50) / 100,
    (randomSeed.nextInt(20) + 50) / 100,
    (randomSeed.nextInt(20) + 50) / 100,
    (randomSeed.nextInt(20) + 50) / 100,
    (randomSeed.nextInt(20) + 50) / 100,
    (randomSeed.nextInt(20) + 50) / 100,
    (randomSeed.nextInt(20) + 50) / 100,
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        WaveWidget(
          config: CustomConfig(
            colors: _colors,
            durations: _durations,
            heightPercentages: _heightPercentages,
          ),
          backgroundColor: const Color.fromARGB(255, 169, 133, 236),
          size: const Size(double.infinity, double.infinity),
          waveAmplitude: 10,
          wavePhase: 999,
          waveFrequency: 3,
        ),
        AnimatedPositioned(
          duration: const Duration(seconds: 1),
          child: Image.asset(
            'assets/atv_logo.png',
            width: 150,
            height: 200,
          ),
        ),
      ],
    );
  }
}
