import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:presc/config/init_config.dart';
import 'package:presc/generated/l10n.dart';
import 'package:presc/model/speech_to_text_manager.dart';
import 'package:presc/view/utils/dialog/silent_dialog_manager.dart';
import 'package:presc/viewModel/playback_timer_provider.dart';
import 'package:provider/provider.dart';
import 'package:presc/viewModel/playback_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sound_mode/permission_handler.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';
import 'package:in_app_review/in_app_review.dart';

class SpeechToTextProvider with ChangeNotifier {
  final _manager = SpeechToTextManager();
  _History _history = _History();
  RingerModeStatus _defaultRingerStatus;

  String _unrecognizedText = "";
  String _recognizedText = "";

  String get unrecognizedText => _unrecognizedText;

  String get recognizedText => _recognizedText;

  bool get canUndo => _history.canUndo();

  bool get canRedo => _history.canRedo();

  double verticalRecognizedWidth = 0;
  double lastOffset = 0;

  void start(BuildContext context) async {
    final timer = context.read<PlaybackTimerProvider>();
    final showSnackBar = (text) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(text),
            duration: const Duration(seconds: 2),
          ),
        );
    if (Platform.isAndroid && await _startSilentMode(context)) return;

    timer.start();
    _manager.speak(
      resultListener: _reflect,
      errorListener: (error) {
        context.read<PlaybackProvider>().playFabState = false;
        context.read<PlaybackTimerProvider>().stop();
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
    );
    notifyListeners();
  }

  void stop() async {
    await _manager.stop();
    await Future.delayed(Duration(milliseconds: 400));
    _stopSilentMode();
  }

  void reset(String content) {
    _recognizedText = "";
    _unrecognizedText = content;
    lastOffset = 0;
    _history.clear();
  }

  void back(BuildContext context) {
    stop();
    context.read<PlaybackProvider>().playFabState = false;
    context.read<PlaybackTimerProvider>().reset();
    _history.clear();
    Navigator.pop(context);
    _requestInAppReview();
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

  List<String> _ngram(String target, int n) => List.generate(
        target.length - n + 1,
        (i) => target.substring(i, i + n),
      );

  void _reflect(String lastWords) {
    final N = InitConfig.ngramNum;
    final rangeUnrecognizedText = unrecognizedText.length > 120
        ? unrecognizedText.substring(0, 120)
        : unrecognizedText;

    final isEnglish = RegExp(r'^[ -~｡-ﾟ]+$').hasMatch(lastWords);
    final splitWord = isEnglish ? lastWords.split(" ") : _ngram(lastWords, N);
    final i = isEnglish ? splitWord.last.length : N;

    int lastIndex = -1;
    splitWord.forEach((t) {
      lastIndex = max(
        rangeUnrecognizedText.toLowerCase().indexOf(t.toLowerCase()),
        lastIndex,
      );
    });

    if (lastIndex != -1) {
      final latestRecognizedText = unrecognizedText.substring(0, lastIndex + i);
      _recognizedText += latestRecognizedText;
      _unrecognizedText = unrecognizedText.substring(lastIndex + i);

      _history.add(recognizedText.length);
      notifyListeners();
    }
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
    final isGranted = await PermissionHandler.permissionsGranted;

    if (ringerModeStatus != RingerModeStatus.normal) {
      prefs.setBool("isSilentHintVisible", true);
      return false;
    } else if (isGranted) {
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
    final isGranted = await PermissionHandler.permissionsGranted;
    if (isGranted) await SoundMode.setSoundMode(_defaultRingerStatus);
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

    if (isTimePassed() && totalSecond >= 10 * 60) {
      prefs.setInt("lastReviewRequest", timestamp);
      prefs.setInt("totalSecond", 0);
      final inAppReview = InAppReview.instance;
      if (await inAppReview.isAvailable()) {
        inAppReview.requestReview();
      }
    }
  }
}

class _History {
  List<int> _undoStack = [];
  List<int> _redoStack = [];

  int get current => canUndo() ? _undoStack.last : 0;

  void undo() {
    if (!canUndo()) return;
    _redoStack.add(_undoStack.last);
    _undoStack.removeLast();
  }

  bool canUndo() => _undoStack.length > 0;

  void redo() {
    if (!canRedo()) return;
    _undoStack.add(_redoStack.last);
    _redoStack.removeLast();
  }

  bool canRedo() => _redoStack.length > 0;

  void add(int position) {
    _undoStack.add(position);
    _redoStack.clear();
  }

  void clear() {
    _undoStack.clear();
    _redoStack.clear();
  }
}
