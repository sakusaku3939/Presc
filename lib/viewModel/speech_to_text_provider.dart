import 'dart:math';

import 'package:flutter/material.dart';
import 'package:presc/model/speech_to_text_manager.dart';
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
        switch (error) {
          case "not_available":
            showSnackBar("音声認識が利用できません");
            break;
          case "error_network":
            showSnackBar("ネットワークエラー");
            break;
          default:
            showSnackBar("エラー: $error");
        }
      },
    );
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
    final rangeUnrecognizedText = unrecognizedText.substring(0, 300);
    int lastIndex = -1;
    _ngram(lastWords, 3).forEach((t) {
      lastIndex = max(rangeUnrecognizedText.indexOf(t), lastIndex);
    });
    if (lastIndex != -1) {
      recognizedText += unrecognizedText.substring(0, lastIndex + 3);
      unrecognizedText = unrecognizedText.substring(lastIndex + 3);
      notifyListeners();
    }
  }
}
