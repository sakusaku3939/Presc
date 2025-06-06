import 'dart:math';

import 'package:flutter/material.dart';
import 'package:presc/features/playback/data/speech_to_text_service.dart';

class VisualizerService {
  final _speechToText = SpeechToTextService();
  static VisualizerService? _instance;
  double? _mediaWidth;

  final distributionHeight = 16;
  final spaceWidth = 2;
  final barWidth = 12;

  int barCount = 0;
  double volume = 0;
  List<double> barHeight = [];

  VisualizerService._();

  void Function(double volume)? volumeChangeListener;

  factory VisualizerService() {
    _instance ??= VisualizerService._();
    return _instance!;
  }

  void init(BuildContext context) {
    _mediaWidth = MediaQuery.of(context).size.width;
    barCount = _mediaWidth! ~/ (barWidth + spaceWidth);
    barHeight = List.generate(barCount, (_) => 0);

    _speechToText.soundLevelListener = (volume) {
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
