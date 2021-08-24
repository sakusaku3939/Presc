import 'package:flutter/material.dart';

class PlaybackTextStyle {
  static TextStyle recognized(PlaybackAxis axis) => TextStyle(
        backgroundColor: Colors.grey[100],
        height: axis == PlaybackAxis.vertical ? 2.2 : 1.3,
        fontSize: 20,
      );

  static TextStyle unrecognized(PlaybackAxis axis) => TextStyle(
    color: Colors.white,
    height: axis == PlaybackAxis.vertical ? 2.2 : 1.3,
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );
}

enum PlaybackAxis {
  vertical,
  horizontal,
}
