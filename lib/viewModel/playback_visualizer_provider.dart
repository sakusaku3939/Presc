import 'dart:math';

import 'package:flutter/material.dart';
import 'package:presc/model/speech_to_text_manager.dart';

class PlaybackVisualizerProvider with ChangeNotifier {
  final _manager = SpeechToTextManager();

  static const _distributionHeight = 24;
  static const _spaceWidth = 2;
  static const barSize = 32;

  List<double> _height = List.generate(barSize, (_) => 0);

  List<double> get height {
    _manager.soundLevelListener ??= (level) {
      if (level < 1) level = 0;
      for (int i = 0; i < barSize; i++) {
        _height[i] = 2 * level +
            Random().nextInt(_distributionHeight).toDouble() * level.sign;
      }
      notifyListeners();
    };
    return _height;
  }

  double width(BuildContext context) =>
      MediaQuery.of(context).size.width / barSize - _spaceWidth;

  void reset() {
    _height = List.generate(barSize, (_) => 0);
    notifyListeners();
  }
}
