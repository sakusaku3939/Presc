import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:presc/core/constants/app_constants.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechToTextService {
  static SpeechToTextService? _instance;

  String words = "";
  String recognizedText = "";
  String lastError = "";
  String lastStatus = "";

  void Function(String recognizedText)? resultListener;
  void Function(String error)? errorListener;
  void Function(String status)? statusListener;
  void Function(double level)? soundLevelListener;

  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isStopFlagValid = false;
  String? _localeId;
  Timer? _timer;

  SpeechToTextService._();

  factory SpeechToTextService() {
    _instance ??= SpeechToTextService._();
    return _instance!;
  }

  Future<void> speak({
    void Function(String recognizedText)? resultListener,
    void Function(String error)? errorListener,
    void Function(String status)? statusListener,
    bool log = true,
    String? localeId,
  }) async {
    this.resultListener = resultListener;
    this.errorListener = errorListener;
    this.statusListener = statusListener;

    bool available = await _speech.initialize(
      onError: _errorListener,
      onStatus: _statusListener,
    );
    if (available) {
      _isStopFlagValid = false;
      final systemLocale = await _speech.systemLocale();
      _localeId = localeId ?? systemLocale?.localeId.replaceAll('_', '-');

      await _speech.listen(
        onResult: _resultListener,
        onSoundLevelChange: _soundLevelListener,
        localeId: _localeId,
      );
      if (log) print("start recognition");
    } else {
      if (log) print("speech recognition not available.");
      if (this.errorListener != null) this.errorListener!("not_available");
    }
  }

  Future<void> stop() async {
    _isStopFlagValid = true;
    recognizedText = "";
    await _speech.stop();
    print("stop recognition");
  }

  Future<void> restart() async {
    await _speech.stop();
    Timer(
      Duration(milliseconds: 600),
      () {
        if (!_isStopFlagValid)
          speak(
            resultListener: this.resultListener,
            errorListener: this.errorListener,
            statusListener: this.statusListener,
            log: false,
            localeId: _localeId,
          );
      },
    );
  }

  void _resultListener(SpeechRecognitionResult result) {
    if (Platform.isAndroid) _resultAndroid(result);
    if (Platform.isIOS) _resultIOS(result);
  }

  void _resultAndroid(SpeechRecognitionResult result) {
    if (!result.finalResult) return;

    recognizedText = result.recognizedWords;
    if (recognizedText.isNotEmpty) {
      print("recognizedText: $recognizedText");
      if (resultListener != null) resultListener!(recognizedText);
    }
  }

  void _resultIOS(SpeechRecognitionResult result) {
    if (result.finalResult) return;

    final latestWordIndex = words.runes.map(
      (rune) => result.recognizedWords.lastIndexOf(String.fromCharCode(rune)),
    );
    words = result.recognizedWords;
    if (latestWordIndex.last != -1 && latestWordIndex.last <= words.length) {
      final latestWord = words.substring(latestWordIndex.last + 1);
      recognizedText += latestWord;
    }

    if (_timer != null && _timer!.isActive) _timer!.cancel();
    _timer = Timer(
      Duration(milliseconds: 500),
      () {
        final N = AppConstants.ngramNum;
        if (_speech.isNotListening || result.finalResult) return;
        if (recognizedText.length < N) recognizedText.padRight(N - 1, ' ');

        print("recognizedText: $recognizedText");
        if (resultListener != null) resultListener!(recognizedText);
        recognizedText = "";
      },
    );
  }

  void _soundLevelListener(double level) {
    double volume = Platform.isIOS ? _convertDbToVolume(level) : level;
    volume = max(0, min(10, volume));
    if (soundLevelListener != null) soundLevelListener!(volume);
  }

  double _convertDbToVolume(double dB) {
    final max = 50, min = 20;
    return (max - dB.abs()) / (max - min) * 10;
  }

  void _errorListener(SpeechRecognitionError error) {
    lastError = error.toString();
    if (error.errorMsg == "error_speech_timeout" ||
        error.errorMsg == "error_no_match") {
      restart();
    } else {
      print(lastError);
      if (errorListener != null) errorListener!(error.errorMsg);
    }
  }

  void _statusListener(String status) {
    lastStatus = status;
    if (lastStatus == "notListening") {
      restart();
    } else {
      if (statusListener != null) statusListener!(status);
    }
  }
}
