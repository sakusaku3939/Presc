import 'dart:math';

import 'package:flutter/material.dart';

class PlaybackProvider with ChangeNotifier {
  String unrecognizedText = "";
  String recognizedText = "";

  bool _playFabState = false;

  bool get playFabState => _playFabState;

  set playFabState(bool state) {
    _playFabState = state;
    notifyListeners();
  }

  List<String> _ngram(String target, int n) =>
      List.generate(target.length - n + 1, (i) => target.substring(i, i + n));

  void reflectRecognizedText(String text) {
    int lastIndex = -1;
    _ngram(text, 3).forEach((t) {
      lastIndex = max(unrecognizedText.indexOf(t), lastIndex);
    });
    if (lastIndex != -1) {
      recognizedText += unrecognizedText.substring(0, lastIndex + 3);
      unrecognizedText = unrecognizedText.substring(lastIndex + 3);
      notifyListeners();
    }
  }
}
