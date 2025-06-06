import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:presc/config/init_config.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechToTextManager {
  static SpeechToTextManager? _instance;

  String words = "";
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";

  void Function(String lastWords)? resultListener;
  void Function(String error)? errorListener;
  void Function(String status)? statusListener;
  void Function(double level)? soundLevelListener;

  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isStopFlagValid = false;
  bool _isCurrentEnglish = false;
  Timer? _timer;

  SpeechToTextManager._();

  factory SpeechToTextManager() {
    _instance ??= SpeechToTextManager._();
    return _instance!;
  }

  Future<void> speak({
    void Function(String lastWords)? resultListener,
    void Function(String error)? errorListener,
    void Function(String status)? statusListener,
    bool log = true,
    bool isEnglish = false
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
      _isCurrentEnglish = isEnglish;
      final systemLocale = await _speech.systemLocale();
      final systemLocalId = Platform.isAndroid ? null : systemLocale?.localeId;
      await _speech.listen(
        onResult: _resultListener,
        onSoundLevelChange: _soundLevelListener,
        localeId: isEnglish ? "en" : systemLocalId,
      );
      if (log) print("start recognition");
    } else {
      if (log) print("speech recognition not available.");
      if (this.errorListener != null) this.errorListener!("not_available");
    }
  }

  Future<void> stop() async {
    _isStopFlagValid = true;
    lastWords = "";
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
            isEnglish: _isCurrentEnglish,
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

    lastWords = result.recognizedWords;
    if (lastWords.isNotEmpty) {
      print("lastWords: $lastWords");
      if (resultListener != null) resultListener!(lastWords);
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
      lastWords += latestWord;
    }

    if (_timer != null && _timer!.isActive) _timer!.cancel();
    _timer = Timer(
      Duration(milliseconds: 500),
      () {
        final N = InitConfig.ngramNum;
        if (_speech.isNotListening || result.finalResult) return;
        if (lastWords.length < N) lastWords.padRight(N - 1, ' ');

        print("lastWords: $lastWords");
        if (resultListener != null) resultListener!(lastWords);
        lastWords = "";
      },
    );
  }

  void _soundLevelListener(double level) {
    double volume = Platform.isIOS ? _convertDbToVolume(level): level;
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
