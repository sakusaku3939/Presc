import 'package:flutter/material.dart';
import 'package:presc/features/playback/ui/providers/playback_provider.dart';

class PlaybackTextStyle {
  static PlaybackTextStyle? _instance;
  static PlaybackProvider? _model;

  PlaybackTextStyle._();

  factory PlaybackTextStyle.of(PlaybackProvider model) {
    _model = model;
    _instance ??= PlaybackTextStyle._();
    return _instance!;
  }

  TextStyle get recognized => TextStyle(
        color: _model!.backgroundColor,
        backgroundColor: _model!.textColor,
        height: _model!.scrollHorizontal ? null : 1.2,
        fontWeight: FontWeight.normal,
        fontSize: _model!.fontSize.toDouble(),
        fontFamily: 'monospace',
      );

  TextStyle get unrecognized => TextStyle(
        color: _model!.textColor,
        height: _model!.scrollHorizontal ? null : 1.2,
        fontWeight: FontWeight.bold,
        fontSize: _model!.fontSize.toDouble(),
        fontFamily: 'monospace',
      );

  StrutStyle get strutStyle => StrutStyle(
        height: _model!.scrollHorizontal ? _model!.fontHeight : 1.2,
        fontSize: _model!.fontSize.toDouble(),
      );
}
