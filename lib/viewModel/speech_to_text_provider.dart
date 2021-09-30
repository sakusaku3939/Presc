import 'dart:math';

import 'package:flutter/material.dart';
import 'package:presc/model/speech_to_text_manager.dart';
import 'package:presc/viewModel/playback_timer_provider.dart';
import 'package:provider/provider.dart';
import 'package:presc/viewModel/playback_provider.dart';

class SpeechToTextProvider with ChangeNotifier {
  final _manager = SpeechToTextManager();

  String unrecognizedText = "";
  String recognizedText = "";

  void start(BuildContext context) {
    final showSnackBar = (text) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(text),
            duration: const Duration(seconds: 2),
          ),
        );
    _manager.speak(
      resultListener: _reflect,
      errorListener: (error) {
        context.read<PlaybackProvider>().playFabState = false;
        context.read<PlaybackTimerProvider>().stop();
        _manager.stop();
        switch (error) {
          case "not_available":
            showSnackBar("音声認識を行うにはマイクの許可が必要です");
            break;
          case "error_network":
            showSnackBar("ネットワークエラーが発生しました");
            break;
          case "error_busy":
            showSnackBar("マイクがビジー状態です");
            break;
          default:
            showSnackBar("エラー: $error");
            break;
        }
      },
    );
    notifyListeners();
  }

  void stop() => _manager.stop();

  void back(BuildContext context) {
    stop();
    context.read<PlaybackProvider>().playFabState = false;
    Navigator.pop(context);
  }

  List<String> _ngram(String target, int n) =>
      List.generate(target.length - n + 1, (i) => target.substring(i, i + n));

  void _reflect(String lastWords) {
    final rangeUnrecognizedText = unrecognizedText.length > 150
        ? unrecognizedText.substring(0, 150)
        : unrecognizedText;
    int lastIndex = -1;
    _ngram(lastWords, 4).forEach((t) {
      lastIndex = max(rangeUnrecognizedText.indexOf(t), lastIndex);
    });
    if (lastIndex != -1) {
      final latestRecognizedText = unrecognizedText.substring(0, lastIndex + 4);
      recognizedText += latestRecognizedText;
      unrecognizedText = unrecognizedText.substring(lastIndex + 4);
      notifyListeners();
    }
  }

  int _countLine(String text) => text.split('\n').where((e) => e == '').length;

  Future<void> _testReflect() async {
    await Future.delayed(Duration(milliseconds: 500));
    _reflect("かとんと");
    await Future.delayed(Duration(milliseconds: 2000));
    _reflect("しかもあとで");
    await Future.delayed(Duration(milliseconds: 2000));
    _reflect("ばかりである");
  }
}
