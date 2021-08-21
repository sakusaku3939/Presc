import 'package:flutter/material.dart';

class PlaybackProvider with ChangeNotifier {
  ScrollController scrollController;

  bool _playFabState = false;

  bool get playFabState => _playFabState;

  set playFabState(bool state) {
    _playFabState = state;
    notifyListeners();
  }
}
