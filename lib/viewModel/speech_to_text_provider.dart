import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:presc/config/init_config.dart';
import 'package:presc/config/punctuation_config.dart';
import 'package:presc/generated/l10n.dart';
import 'package:presc/model/hiragana.dart';
import 'package:presc/model/language.dart';
import 'package:presc/model/speech_to_text_manager.dart';
import 'package:presc/model/undo_redo_history.dart';
import 'package:presc/view/utils/dialog/silent_dialog_manager.dart';
import 'package:presc/viewModel/playback_provider.dart';
import 'package:presc/viewModel/playback_timer_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sound_mode/permission_handler.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';

class SpeechToTextProvider with ChangeNotifier {
  final _manager = SpeechToTextManager();
  final _history = UndoRedoHistory(0);
  final _hiragana = Hiragana();
  RingerModeStatus? _defaultRingerStatus;

  String _unrecognizedText = "";
  String _recognizedText = "";

  String get unrecognizedText => _unrecognizedText;

  String get recognizedText => _recognizedText;

  bool get canUndo => _history.canUndo();

  bool get canRedo => _history.canRedo();

  bool _isProcessing = false;

  bool get isProcessing => _isProcessing;

  set isProcessing(process) {
    _isProcessing = process;
    notifyListeners();
  }

  double verticalRecognizedWidth = 0;
  double lastOffset = 0;

  // ネットワーク速度に応じてマッチング方法を動的に切り替える
  bool _useSlowNetworkMode = false;

  void start(BuildContext context) async {
    if (Platform.isAndroid && await _startSilentMode(context)) return;

    final showSnackBar = (text) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(text),
            duration: const Duration(seconds: 2),
          ),
        );
    final timer = context.read<PlaybackTimerProvider>();
    timer.start();

    _manager.speak(
      resultListener: _reflect,
      errorListener: (error) {
        final playback = context.read<PlaybackProvider>();
        playback.playFabState = false;

        timer.stop();
        _manager.stop();

        switch (error) {
          case "not_available":
            showSnackBar(S.current.requirePermission);
            break;
          case "error_network":
            showSnackBar(S.current.networkError);
            break;
          case "error_busy":
            showSnackBar(S.current.micBusy);
            break;
          default:
            showSnackBar(S.current.error(error));
            break;
        }
      },
      isEnglish: Language.isEnglish(_unrecognizedText),
    );
    notifyListeners();
  }

  void stop() async {
    await _manager.stop();
    await Future.delayed(Duration(milliseconds: 400));
    _stopSilentMode();
  }

  Future<HiraganaResult?> _convertWithNetworkFallback(String text) async {
    if (_useSlowNetworkMode) {
      return null;
    }

    try {
      final stopwatch = Stopwatch()..start();

      final result = await Future.any([
        _hiragana.convert(text),
        Future.delayed(
          Duration(milliseconds: InitConfig.hiraganaNetworkTimeoutMs),
          () => null,
        ),
      ]);

      stopwatch.stop();
      final elapsedMs = stopwatch.elapsedMilliseconds;

      // ネットワーク速度が閾値を超えた場合はn-gramモードに切り替える
      if (elapsedMs > InitConfig.hiraganaSlowNetworkThresholdMs ||
          result == null) {
        _useSlowNetworkMode = true;
        print('ネットワークが遅いため、n-gramモードに切り替えました (${elapsedMs}ms)');
        return null;
      }

      return result;
    } catch (e) {
      print('ひらがな変換でエラーが発生: $e');
      _useSlowNetworkMode = true;
      return null;
    }
  }

  void _reflect(String recognizedText) async {
    isProcessing = true;

    try {
      final rangeText = _prepareRangeText(recognizedText);
      final textPosition =
          await _calculateTextPosition(recognizedText, rangeText);
      _applyRecognitionResult(textPosition);
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  String _prepareRangeText(String recognizedText) {
    final isLatinAlphabet = Language.isLatinAlphabet(recognizedText);
    final range = !isLatinAlphabet ? 120 : 240;

    return unrecognizedText.length > range
        ? unrecognizedText.substring(0, range)
        : unrecognizedText;
  }

  Future<TextPosition> _calculateTextPosition(
    String recognizedText,
    String rangeText,
  ) async {
    final isLatinAlphabet = Language.isLatinAlphabet(recognizedText);

    if (isLatinAlphabet) {
      return _calculateLatinTextPosition(recognizedText, rangeText);
    } else {
      return await _calculateJapaneseTextPosition(recognizedText, rangeText);
    }
  }

  TextPosition _calculateLatinTextPosition(
    String recognizedText,
    String rangeText,
  ) {
    final words = recognizedText.split(" ").where((w) => w.isNotEmpty).toList();
    final filteredText = rangeText.toLowerCase().replaceAllMapped(
          RegExp(r'[^\w\s]'), // 英数字とスペース以外の文字を除外
          (match) => " ",
        );
    final splitRangeWords = filteredText.split(" ");

    // bigramを使用してマッチングする
    if (words.length >= 2) {
      final bigrams = List.generate(
        words.length - 1,
        (i) => "${words[i]} ${words[i + 1]}".toLowerCase(),
      );

      // 連続する2語の位置を逆順で検索する
      int foundIndex = -1;
      for (int bigramIdx = bigrams.length - 1; bigramIdx >= 0; bigramIdx--) {
        final bigram = bigrams[bigramIdx];
        final bigramWords = bigram.split(" ");

        for (int i = 0; i < splitRangeWords.length - 1; i++) {
          if (splitRangeWords[i] == bigramWords[0] &&
              splitRangeWords[i + 1] == bigramWords[1]) {
            // 最初に見つかった位置を記録
            foundIndex = i;
            break;
          }
        }

        // マッチしたら終了
        if (foundIndex != -1) {
          break;
        }
      }

      if (foundIndex != -1) {
        final textLen =
            splitRangeWords.sublist(0, foundIndex).join().length + foundIndex;
        final matchedWordLength =
            "${splitRangeWords[foundIndex]} ${splitRangeWords[foundIndex + 1]}"
                .length;
        return TextPosition(textLen, matchedWordLength);
      }
    }

    return TextPosition.notFound();
  }

  Future<TextPosition> _calculateJapaneseTextPosition(
    String recognizedText,
    String rangeText,
  ) async {
    // 音声認識された文章と、現在の場所から120文字以内の文章をひらがなに変換
    // ただし、ネットワーク速度に応じてn-gramにフォールバックする
    final res = await Future.wait([
      _convertWithNetworkFallback(recognizedText),
      _convertWithNetworkFallback(rangeText),
    ]);
    final recognizedTextResult = res.first;
    final rangeTextResult = res.last;

    if (recognizedTextResult != null && rangeTextResult != null) {
      return _calculateHiraganaTextPosition(
          recognizedTextResult, rangeTextResult);
    } else {
      return _calculateNgramTextPosition(recognizedText, rangeText);
    }
  }

  TextPosition _calculateHiraganaTextPosition(
    HiraganaResult recognizedTextResult,
    HiraganaResult rangeTextResult,
  ) {
    // 形態素解析されたひらがな文章から、最初に一致したindexを取得
    final hiraganaFirstIndex = _findHiraganaFirstIndex(
      recognizedText: recognizedTextResult.hiragana,
      rangeText: rangeTextResult.hiragana,
    );

    if (hiraganaFirstIndex != -1) {
      final origin = rangeTextResult.origin;
      final rangeOrigin = origin.sublist(0, hiraganaFirstIndex);
      final textLen = rangeOrigin.join().length;
      final matchedWordLength = origin[hiraganaFirstIndex].length;
      return TextPosition(textLen, matchedWordLength);
    } else {
      return TextPosition.notFound();
    }
  }

  TextPosition _calculateNgramTextPosition(
    String recognizedText,
    String rangeText,
  ) {
    // ひらがなへの変換に失敗した場合（タイムアウト含む）はN-gramで分割
    print('n-gramモードで処理中...');
    final N = InitConfig.ngramNum;
    final textLen = _findTextIndex(
      rangeText.toLowerCase(),
      splitWords: _charNgram(recognizedText, N),
    );
    return TextPosition(textLen, N);
  }

  void _applyRecognitionResult(TextPosition position) {
    // 認識結果を画面に反映する
    if (position.isFound) {
      final latestRecognizedText = unrecognizedText.substring(
          0, position.textLen + position.matchedWordLength);
      _recognizedText += latestRecognizedText;
      _unrecognizedText = unrecognizedText
          .substring(position.textLen + position.matchedWordLength);
      _history.add(recognizedText.length);
    }
  }

  List<String> _charNgram(String target, int n) => List.generate(
        target.length - n + 1,
        (i) => target.substring(i, i + n),
      );

  int _findTextIndex(
    dynamic text, {
    required List<String> splitWords,
  }) {
    int foundIndex = -1;

    // 文字列を逆順に検索し、最初に見つかった位置を取得する
    for (int i = splitWords.length - 1; i >= 0; i--) {
      final word = splitWords[i];
      final index = text.indexOf(word.toLowerCase().trim());
      if (index != -1) {
        foundIndex = index;
        break;
      }
    }

    return foundIndex;
  }

  int _findHiraganaFirstIndex({
    required List<String> recognizedText,
    required List<String> rangeText,
  }) {
    int foundIndex = -1;

    // 文字列を逆順に検索し、最初に見つかった位置を取得する
    for (int i = recognizedText.length - 1; i >= 0; i--) {
      final word = recognizedText[i].trim();

      for (int j = 0; j < rangeText.length; j++) {
        if (rangeText[j].trim() == word) {
          final isPunctuation = PunctuationConfig.list.contains(word);
          if (!isPunctuation) {
            foundIndex = j;
            break;
          }
        }
      }

      if (foundIndex != -1) {
        break;
      }
    }

    return foundIndex;
  }

  void resetNetworkMode() {
    _useSlowNetworkMode = false;
  }

  Future<void> _testReflect() async {
    await Future.delayed(Duration(milliseconds: 500));
    _reflect("たかとんと");
    await Future.delayed(Duration(milliseconds: 2000));
    _reflect("しかもあとで");
    await Future.delayed(Duration(milliseconds: 2000));
    _reflect("思わなかった");
  }

  Future<void> _testReflectEn() async {
    await Future.delayed(Duration(milliseconds: 500));
    _reflect("they");
    await Future.delayed(Duration(milliseconds: 2000));
    _reflect("internet");
    await Future.delayed(Duration(milliseconds: 2000));
    _reflect("keyboards");
  }

  Future<bool> _startSilentMode(BuildContext context) async {
    await SoundMode.setSoundMode(RingerModeStatus.unknown);
    final ringerModeStatus = await SoundMode.ringerModeStatus;
    final prefs = await SharedPreferences.getInstance();
    final permission = await PermissionHandler.permissionsGranted;

    if (ringerModeStatus != RingerModeStatus.normal) {
      prefs.setBool("isSilentHintVisible", true);
      return false;
    } else if (permission == true) {
      prefs.setBool("isSilentHintVisible", true);
      _defaultRingerStatus = ringerModeStatus;
      await SoundMode.setSoundMode(RingerModeStatus.silent);
      return false;
    } else if (prefs.getBool("isSilentHintVisible") ?? true) {
      return await SilentDialogManager.show(context);
    } else {
      return false;
    }
  }

  Future<void> _stopSilentMode() async {
    final permission = await PermissionHandler.permissionsGranted;
    if (permission == true && _defaultRingerStatus != null) {
      await SoundMode.setSoundMode(_defaultRingerStatus!);
    }
  }

  Future<void> _requestInAppReview() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final timestamp = now.millisecondsSinceEpoch;
    final lastTimestamp = prefs.getInt("lastReviewRequest");
    final totalSecond = prefs.getInt("totalSecond");

    final isTimePassed = () {
      if (lastTimestamp != null) {
        final lastDate = DateTime.fromMillisecondsSinceEpoch(lastTimestamp);
        final difference = now.difference(lastDate);
        return difference.inDays >= 3 * 30;
      } else {
        return true;
      }
    };

    if (isTimePassed() && totalSecond != null && totalSecond >= 10 * 60) {
      prefs.setInt("lastReviewRequest", timestamp);
      prefs.setInt("totalSecond", 0);
      final inAppReview = InAppReview.instance;
      if (await inAppReview.isAvailable()) {
        inAppReview.requestReview();
      }
    }
  }

  void undo() {
    if (!_history.canUndo()) return;
    _history.undo();
    _reflectText();
  }

  void redo() {
    if (!_history.canRedo()) return;
    _history.redo();
    _reflectText();
  }

  void _reflectText() {
    final text = recognizedText + unrecognizedText;
    _recognizedText = text.substring(0, _history.current);
    _unrecognizedText = text.substring(_history.current);
    notifyListeners();
  }

  void reset(String content) {
    _recognizedText = "";
    _unrecognizedText = content;
    lastOffset = 0;
    _isProcessing = false;
    _history.clear();
    resetNetworkMode();
  }

  void back(BuildContext context) {
    final playback = context.read<PlaybackProvider>();
    final timer = context.read<PlaybackTimerProvider>();

    stop();
    playback.playFabState = false;
    timer.reset();
    _history.clear();

    Navigator.pop(context);
    _requestInAppReview();
  }
}

/// テキスト位置情報を表すクラス
class TextPosition {
  final int textLen;
  final int matchedWordLength;

  const TextPosition(this.textLen, this.matchedWordLength);

  const TextPosition.notFound()
      : textLen = -1,
        matchedWordLength = 0;

  bool get isFound => textLen != -1;
}
