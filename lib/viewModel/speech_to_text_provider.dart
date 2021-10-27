import 'dart:math';

import 'package:flutter/material.dart';
import 'package:presc/model/speech_to_text_manager.dart';
import 'package:presc/view/utils/dialog/dialog_manager.dart';
import 'package:presc/viewModel/playback_timer_provider.dart';
import 'package:provider/provider.dart';
import 'package:presc/viewModel/playback_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sound_mode/permission_handler.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';

class SpeechToTextProvider with ChangeNotifier {
  final _manager = SpeechToTextManager();
  RingerModeStatus _defaultRingerStatus;

  String unrecognizedText = "";
  String recognizedText = "";
  double lastOffset = 0;

  void start(BuildContext context) async {
    final timer = context.read<PlaybackTimerProvider>();
    final showSnackBar = (text) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(text),
            duration: const Duration(seconds: 2),
          ),
        );
    if (!await _startSilentMode(context)) return;

    timer.start();
    _manager.speak(
      resultListener: _reflect,
      errorListener: (error) {
        context.read<PlaybackProvider>().playFabState = false;
        context.read<PlaybackTimerProvider>().stop();
        _manager.stop();
        switch (error) {
          case "not_available":
            showSnackBar("音声認識を行うにはマイクの許可が必要です");
            break;
          case "error_network":
            showSnackBar("ネットワークエラーが発生しました");
            break;
          case "error_busy":
            showSnackBar("マイクがビジー状態です");
            break;
          default:
            showSnackBar("エラー: $error");
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

  void back(BuildContext context) {
    stop();
    context.read<PlaybackProvider>().playFabState = false;
    Navigator.pop(context);
  }

  List<String> _ngram(String target, int n) =>
      List.generate(target.length - n + 1, (i) => target.substring(i, i + n));

  void _reflect(String lastWords) {
    final rangeUnrecognizedText = unrecognizedText.length > 150
        ? unrecognizedText.substring(0, 150)
        : unrecognizedText;
    int lastIndex = -1;
    _ngram(lastWords, 4).forEach((t) {
      lastIndex = max(rangeUnrecognizedText.indexOf(t), lastIndex);
    });
    if (lastIndex != -1) {
      final latestRecognizedText = unrecognizedText.substring(0, lastIndex + 4);
      recognizedText += latestRecognizedText;
      unrecognizedText = unrecognizedText.substring(lastIndex + 4);
      notifyListeners();
    }
  }

  Future<void> _testReflect() async {
    await Future.delayed(Duration(milliseconds: 500));
    _reflect("かとんと");
    await Future.delayed(Duration(milliseconds: 2000));
    _reflect("しかもあとで");
    await Future.delayed(Duration(milliseconds: 2000));
    _reflect("ばかりである");
  }

  Future<bool> _startSilentMode(BuildContext context) async {
    await SoundMode.setSoundMode(RingerModeStatus.unknown);
    final ringerModeStatus = await SoundMode.ringerModeStatus;
    if (ringerModeStatus != RingerModeStatus.normal) return true;

    final prefs = await SharedPreferences.getInstance();
    final isGranted = await PermissionHandler.permissionsGranted;
    bool isChecked = false;
    bool isLaunchSetting = false;

    if (isGranted) {
      prefs.setBool("isSilentHintVisible", true);
      _defaultRingerStatus = ringerModeStatus;
      await SoundMode.setSoundMode(RingerModeStatus.silent);
    } else if (prefs.getBool("isSilentHintVisible") ?? true) {
      await showDialog(
        context: context,
        builder: (_) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "ヒント:",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "再生中に音を鳴らしたくない場合",
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 12),
                    Image.asset(
                      'assets/images/screenshot/silent_mode.png',
                      alignment: Alignment.center,
                    ),
                    SizedBox(height: 12),
                    CheckboxListTile(
                      dense: true,
                      title: Text(
                        "今後は表示しない",
                        style: TextStyle(fontSize: 14),
                      ),
                      contentPadding: EdgeInsets.all(0),
                      value: isChecked,
                      onChanged: (value) => setState(() {
                        isChecked = value;
                      }),
                    ),
                  ],
                ),
                contentPadding: EdgeInsets.fromLTRB(24, 20, 24, 2),
                actions: [
                  DialogTextButton(
                    "設定を開く",
                    onPressed: () {
                      isLaunchSetting = true;
                      context.read<PlaybackProvider>().playFabState = false;
                      Navigator.pop(context);
                      PermissionHandler.openDoNotDisturbSetting();
                    },
                  ),
                  SizedBox(width: 2),
                ],
              );
            },
          );
        },
      );
      if (isLaunchSetting) return false;
      if (isChecked) prefs.setBool("isSilentHintVisible", false);
    }
    return true;
  }

  Future<void> _stopSilentMode() async {
    final isGranted = await PermissionHandler.permissionsGranted;
    if (isGranted) await SoundMode.setSoundMode(_defaultRingerStatus);
  }
}
