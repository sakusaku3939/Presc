import 'dart:async';

import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechToText {
  static SpeechToText _instance;

  String lastWords = "";
  String lastError = "";
  String lastStatus = "";

  void Function(String lastWords) resultListener;
  void Function(String error) errorListener;
  void Function(String status) statusListener;

  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isStopFlagValid = false;

  SpeechToText._();

  factory SpeechToText() {
    _instance ??= SpeechToText._();
    return _instance;
  }

  Future<void> speak({
    void Function(String lastWords) resultListener,
    void Function(String error) errorListener,
    void Function(String status) statusListener,
  }) async {
    this.resultListener = resultListener;
    this.errorListener = errorListener;
    this.statusListener = statusListener;
    bool available = await _speech.initialize(
        onError: _errorListener, onStatus: _statusListener);
    if (available) {
      _isStopFlagValid = false;
      _speech.listen(onResult: _resultListener);
    } else {
      print("speech recognition not available.");
      this.errorListener("not_available");
    }
  }

  Future<void> stop() async {
    _isStopFlagValid = true;
    _speech.stop();
  }

  void restart() {
    stop();
    Timer(Duration(milliseconds: 500), speak);
  }

  void _resultListener(SpeechRecognitionResult result) {
    lastWords = result.recognizedWords;
    if (resultListener != null) resultListener(lastWords);
  }

  void _errorListener(SpeechRecognitionError error) {
    lastError = error.toString();
    if (error.errorMsg == "error_speech_timeout") {
      restart();
    } else {
      print(lastError);
      if (errorListener != null) errorListener(error.errorMsg);
    }
  }

  void _statusListener(String status) {
    lastStatus = status;
    if (!_isStopFlagValid && lastStatus == "notListening") {
      restart();
    } else {
      if (statusListener != null) statusListener(status);
    }
  }
}
