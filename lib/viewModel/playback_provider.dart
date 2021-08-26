import 'package:flutter/material.dart';
import 'package:presc/config/color_config.dart';

class PlaybackProvider with ChangeNotifier {
  bool _playFabState = false;

  bool get playFabState => _playFabState;

  set playFabState(bool state) {
    _playFabState = state;
    notifyListeners();
  }

  ScrollMode _scrollMode = ScrollMode.recognition;

  ScrollMode get scrollMode => _scrollMode;

  set scrollMode(ScrollMode mode) {
    _scrollMode = mode;
    notifyListeners();
  }

  bool _scrollVertical = true;

  bool get scrollVertical => _scrollVertical;

  set scrollVertical(bool vertical) {
    _scrollVertical = vertical;
    notifyListeners();
  }

  double _scrollSpeedMagnification = 1.0;

  double get scrollSpeedMagnification => _scrollSpeedMagnification;

  set scrollSpeedMagnification(double value) {
    _scrollSpeedMagnification = value;
    notifyListeners();
  }

  int _fontSize = 20;

  int get fontSize => _fontSize;

  set fontSize(int size) {
    _fontSize = size;
    notifyListeners();
  }

  double _fontHeight = 2.4;

  double get fontHeight => _fontHeight;

  set fontHeight(double height) {
    _fontHeight = height;
    notifyListeners();
  }

  Color _backgroundColor = ColorConfig.playbackBackgroundColor;

  Color get backgroundColor => _backgroundColor;

  set backgroundColor(Color color) {
    _backgroundColor = color;
    notifyListeners();
  }

  Color _textColor = ColorConfig.playbackTextColor;

  Color get textColor => _textColor;

  set textColor(Color color) {
    _textColor = color;
    notifyListeners();
  }
}

enum ScrollMode {
  manual,
  auto,
  recognition,
}
