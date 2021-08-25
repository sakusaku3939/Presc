import 'dart:async';

import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechToTextManager {
  static SpeechToTextManager _instance;

  String lastWords = "";
  String lastError = "";
  String lastStatus = "";

  void Function(String lastWords) resultListener;
  void Function(String error) errorListener;
  void Function(String status) statusListener;
  void Function(double level) soundLevelListener;

  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isStopFlagValid = false;

  SpeechToTextManager._();

  factory SpeechToTextManager() {
    _instance ??= SpeechToTextManager._();
    return _instance;
  }

  Future<void> speak({
    void Function(String lastWords) resultListener,
    void Function(String error) errorListener,
    void Function(String status) statusListener,
    bool log = true,
  }) async {
    this.resultListener = resultListener;
    this.errorListener = errorListener;
    this.statusListener = statusListener;
    bool available = await _speech.initialize(
        onError: _errorListener, onStatus: _statusListener);
    if (available) {
      _isStopFlagValid = false;
      await _speech.listen(
        onResult: _resultListener,
        onSoundLevelChange: _soundLevelListener,
      );
      if (log) print("start recognition");
    } else {
      if (log) print("speech recognition not available.");
      this.errorListener("not_available");
    }
  }

  Future<void> stop({bool log = true}) async {
    _isStopFlagValid = true;
    if (_speech.isListening) {
      await _speech.stop();
      if (log) print("stop recognition");
    }
  }

  Future<void> restart() async {
    await stop(log: false);
    Timer(
      Duration(milliseconds: 500),
      () => speak(
        resultListener: this.resultListener,
        errorListener: this.errorListener,
        statusListener: this.statusListener,
        log: false,
      ),
    );
  }

  void _resultListener(SpeechRecognitionResult result) {
    lastWords = result.recognizedWords;
    if (result.finalResult && lastWords.isNotEmpty) {
      print("result: ${result.recognizedWords}");
      if (resultListener != null) resultListener(lastWords);
    }
  }

  void _soundLevelListener(double level) {
    if (soundLevelListener != null) soundLevelListener(level);
  }

  void _errorListener(SpeechRecognitionError error) {
    lastError = error.toString();
    if (error.errorMsg == "error_speech_timeout" ||
        error.errorMsg == "error_no_match") {
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
