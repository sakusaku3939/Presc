import 'dart:math';

import 'package:flutter/material.dart';
import 'package:presc/model/speech_to_text.dart';
import 'package:provider/provider.dart';
import 'package:presc/viewModel/playback_provider.dart';

class SpeechToTextProvider with ChangeNotifier {
  final _speech = SpeechToText();

  String unrecognizedText = "";
  String recognizedText = "";

  void start(BuildContext context) {
    _speech.speak(
      resultListener: (lastWords) => reflect(lastWords),
      errorListener: (error) {
        context.read<PlaybackProvider>().playFabState = false;
        switch (error) {
          case "not_available":
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "音声認識が利用できません",
                ),
                duration: const Duration(seconds: 2),
              ),
            );
            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "エラー: $error",
                ),
                duration: const Duration(seconds: 2),
              ),
            );
            break;
        }
      },
    );
  }

  List<String> _ngram(String target, int n) =>
      List.generate(target.length - n + 1, (i) => target.substring(i, i + n));

  void reflect(String text) {
    int lastIndex = -1;
    _ngram(text, 3).forEach((t) {
      lastIndex = max(unrecognizedText.indexOf(t), lastIndex);
    });
    if (lastIndex != -1) {
      recognizedText += unrecognizedText.substring(0, lastIndex + 3);
      unrecognizedText = unrecognizedText.substring(lastIndex + 3);
      notifyListeners();
    }
  }
}
