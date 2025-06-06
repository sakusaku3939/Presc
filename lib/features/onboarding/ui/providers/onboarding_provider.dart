import 'package:flutter/material.dart';

class OnBoardingProvider with ChangeNotifier {
  double _position = 0;

  double get position => _position;

  set position(double position) {
    _position = position;
    notifyListeners();
  }
}
