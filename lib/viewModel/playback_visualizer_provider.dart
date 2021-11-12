import 'dart:math';

import 'package:flutter/material.dart';
import 'package:presc/model/speech_to_text_manager.dart';
import 'package:presc/model/visualizer.dart';

class PlaybackVisualizerProvider with ChangeNotifier {
  final _visualizer = Visualizer();
  double _volume = 0;

  int get barSize => _visualizer.barCount;

  double get volume => _volume;

  List<double> get barHeight => _visualizer.barHeight;

  double get barWidth => _visualizer.barWidth.toDouble();

  void init(BuildContext context) {
    _visualizer.init(context);
    _visualizer.volumeChangeListener = (volume) {
      _volume = volume;
      notifyListeners();
    };
  }

  void reset() {
    _visualizer.reset();
    notifyListeners();
  }
}
