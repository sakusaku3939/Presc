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
  static const int _networkTimeoutMs = 3000;
  static const int _slowNetworkThresholdMs = 2000; // n-gramに切り替える閾値

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
      // ネットワーク速度が遅い場合はn-gramを使用
      return null;
    }

    try {
      final stopwatch = Stopwatch()..start();

      final result = await Future.any([
        _hiragana.convert(text),
        Future.delayed(Duration(milliseconds: _networkTimeoutMs), () => null),
      ]);

      stopwatch.stop();
      final elapsedMs = stopwatch.elapsedMilliseconds;

      // ネットワーク速度が遅い、または変換結果がnullの場合はn-gramモードに切り替える
      if (elapsedMs > _slowNetworkThresholdMs || result == null) {
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

  void _reflect(String lastWords) async {
    isProcessing = true;

    final N = InitConfig.ngramNum;
    final isLatinAlphabet = Language.isLatinAlphabet(lastWords);
    int textLen, odd = 0;

    final range = !isLatinAlphabet ? 120 : 240;
    final rangeUnrecognizedText = unrecognizedText.length > range
        ? unrecognizedText.substring(0, range)
        : unrecognizedText;

    if (isLatinAlphabet) {
      // アルファベットの場合は空白で区切ってn-gramを使用
      final splitText = rangeUnrecognizedText.split(" ");
      final index = _findTextIndex(
        splitText.map((e) => e.toLowerCase()).toList(),
        splitWords: lastWords.split(" "),
      );
      if (index != -1) {
        textLen = splitText.sublist(0, index).join().length + index;
        odd = splitText[index].length;
      } else {
        textLen = -1;
      }
    } else {
      // 音声認識された文章と、現在の場所から120文字以内の文章をひらがなに変換
      // ただし、ネットワーク速度に応じてn-gramにフォールバックする
      final res = await Future.wait([
        _convertWithNetworkFallback(lastWords),
        _convertWithNetworkFallback(rangeUnrecognizedText),
      ]);
      final lastWordsResult = res.first;
      final rangeTextResult = res.last;

      if (lastWordsResult != null && rangeTextResult != null) {
        // 形態素解析されたひらがな文章から、最後に一致したindexを取得
        final hiraganaLastIndex = _findHiraganaLastIndex(
          lastWords: lastWordsResult.hiragana,
          rangeText: rangeTextResult.hiragana,
        );
        if (hiraganaLastIndex != -1) {
          final origin = rangeTextResult.origin;
          final rangeOrigin = origin.sublist(0, hiraganaLastIndex);

          textLen = rangeOrigin.join().length;
          odd = origin[hiraganaLastIndex].length;
        } else {
          textLen = -1;
        }
      } else {
        // ひらがなへの変換に失敗した場合（タイムアウト含む）はN-gramで分割
        print('n-gramモードで処理中...');
        textLen = _findTextIndex(
          rangeUnrecognizedText.toLowerCase(),
          splitWords: _ngram(lastWords, N),
        );
        odd = N;
      }
    }

    // 認識結果を画面に反映する
    if (textLen != -1) {
      final latestRecognizedText = unrecognizedText.substring(0, textLen + odd);
      _recognizedText += latestRecognizedText;
      _unrecognizedText = unrecognizedText.substring(textLen + odd);

      _history.add(recognizedText.length);
    }
    _isProcessing = false;
    notifyListeners();
  }

  List<String> _ngram(String target, int n) => List.generate(
        target.length - n + 1,
        (i) => target.substring(i, i + n),
      );

  int _findTextIndex(
    dynamic text, {
    required List<String> splitWords,
  }) {
    int lastIndex = -1;
    splitWords.forEach((t) {
      lastIndex = max(text.indexOf(t.toLowerCase()), lastIndex);
    });
    return lastIndex;
  }

  int _findHiraganaLastIndex({
    required List<String> lastWords,
    required List<String> rangeText,
  }) {
    int hiraganaLastIndex = -1;
    int excludeIndex = 0;

    for (int i = 0; i < lastWords.length; i++) {
      final index = rangeText.indexOf(lastWords[i]);
      if (index == -1) continue;

      final isHighIndex = hiraganaLastIndex < index + excludeIndex;
      final isPunctuation = PunctuationConfig.list.contains(
        rangeText[index],
      );

      if (isHighIndex && !isPunctuation) {
        rangeText = rangeText.sublist(index + 1);
        hiraganaLastIndex = index + excludeIndex;
        excludeIndex = hiraganaLastIndex + 1;
      }
    }
    return hiraganaLastIndex;
  }

  // ネットワークモードをリセットする
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
