import 'package:flutter/material.dart';
import 'package:presc/viewModel/playback_provider.dart';

class PlaybackTextStyle {
  static PlaybackTextStyle _instance;
  static PlaybackProvider _model;

  PlaybackTextStyle._();

  factory PlaybackTextStyle.of(PlaybackProvider model) {
    _model = model;
    _instance ??= PlaybackTextStyle._();
    return _instance;
  }

  TextStyle get recognized => TextStyle(
        backgroundColor: Colors.grey[100],
        height: _model.scrollVertical ? 2.2 : 1.3,
        fontSize: _model.fontSize.toDouble(),
      );

  TextStyle get unrecognized => TextStyle(
        color: Colors.white,
        height: _model.scrollVertical ? 2.2 : 1.3,
        fontWeight: FontWeight.bold,
        fontSize: _model.fontSize.toDouble(),
      );
}