import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:presc/generated/l10n.dart';
import 'package:presc/model/language.dart';
import 'package:presc/model/speech_to_text_manager.dart';
import 'package:presc/model/text_matching_manager.dart';
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
  final _speechToTextManager = SpeechToTextManager();
  final _history = UndoRedoHistory(0);
  final _textMatchingManager = TextMatchingManager();
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

    _speechToTextManager.speak(
      resultListener: _reflect,
      errorListener: (error) {
        final playback = context.read<PlaybackProvider>();
        playback.playFabState = false;

        timer.stop();
        _speechToTextManager.stop();

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
    await _speechToTextManager.stop();
    await Future.delayed(Duration(milliseconds: 400));
    _stopSilentMode();
  }

  void _reflect(String recognizedText) async {
    isProcessing = true;

    try {
      final textPosition = await _textMatchingManager.calculateTextPosition(
          recognizedText, _unrecognizedText);
      _applyRecognitionResult(textPosition);
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  void _applyRecognitionResult(TextPosition position) {
    // 認識結果を画面に反映する
    if (position.isFound) {
      final latestRecognizedText = unrecognizedText.substring(
        0,
        position.textLen + position.matchedWordLength,
      );
      _recognizedText += latestRecognizedText;
      _unrecognizedText = unrecognizedText
          .substring(position.textLen + position.matchedWordLength);
      _history.add(recognizedText.length);
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
    _textMatchingManager.resetNetworkMode();
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
