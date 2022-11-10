import 'dart:math';

import 'package:flutter/material.dart';
import 'package:presc/model/speech_to_text_manager.dart';

class Visualizer {
  final _manager = SpeechToTextManager();
  static Visualizer? _instance;
  double? _mediaWidth;

  final distributionHeight = 16;
  final spaceWidth = 2;
  final barWidth = 12;

  int barCount = 0;
  double volume = 0;
  List<double> barHeight = [];

  Visualizer._();

  void Function(double volume)? volumeChangeListener;

  factory Visualizer() {
    _instance ??= Visualizer._();
    return _instance!;
  }

  void init(BuildContext context) {
    _mediaWidth = MediaQuery.of(context).size.width;
    barCount = _mediaWidth! ~/ (barWidth + spaceWidth);
    barHeight = List.generate(barCount, (_) => 0);

    _manager.soundLevelListener = (volume) {
      for (int i = 0; i < barCount; i++) {
        barHeight[i] = 2 * volume +
            Random().nextInt(distributionHeight).toDouble() * volume.sign;
      }
      this.volume = volume;
      if (volumeChangeListener != null) volumeChangeListener!(volume);
    };
  }

  void reset() {
    barHeight = List.generate(barCount, (_) => 0);
  }
}
