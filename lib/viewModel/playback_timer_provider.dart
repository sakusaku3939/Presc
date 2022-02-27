import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlaybackTimerProvider with ChangeNotifier {
  Timer _timer;
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
    if (_timer != null && _timer.isActive) _timer.cancel();
  }

  void reset() {
    stop();
    final previousTime = _time;
    _time = DateTime.utc(0, 0, 0);
    SharedPreferences.getInstance().then((prefs) {
      final totalSecond = prefs.getInt("totalSecond") ?? 0;
      prefs.setInt("totalSecond", totalSecond + previousTime.second);
    });
    notifyListeners();
  }
}
