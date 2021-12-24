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
        color: _model.backgroundColor,
        backgroundColor: _model.textColor,
        height: _model.fontHeight,
        fontWeight: FontWeight.normal,
        fontSize: _model.fontSize.toDouble(),
      );

  TextStyle get unrecognized => TextStyle(
        color: _model.textColor,
        height: _model.fontHeight,
        fontWeight: FontWeight.bold,
        fontSize: _model.fontSize.toDouble(),
      );

  TextStyle get calculation => TextStyle(
        height: _model.fontHeight,
        fontSize: _model.fontSize.toDouble(),
      );
}
