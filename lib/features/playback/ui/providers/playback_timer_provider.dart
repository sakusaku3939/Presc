import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlaybackTimerProvider with ChangeNotifier {
  Timer? _timer;
  DateTime _time = DateTime.utc(0, 0, 0);

  String get time => DateFormat("mm:ss").format(_time);

  void start() {
    stop();
    _timer = Timer.periodic(
      Duration(seconds: 1),
      (Timer timer) {
        _time = _time.add(Duration(seconds: 1));
        notifyListeners();
      },
    );
  }

  void stop() {
    if (_timer != null && _timer!.isActive) _timer!.cancel();
  }

  Future<void> reset() async {
    stop();
    final elapsedSeconds = _time.difference(DateTime.utc(0, 0, 0)).inSeconds;
    _time = DateTime.utc(0, 0, 0);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final totalSecond = prefs.getInt("totalSecond") ?? 0;
    await prefs.setInt("totalSecond", totalSecond + elapsedSeconds);
  }
}
