import 'package:flutter/material.dart';
import 'package:presc/viewModel/playback_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sound_mode/permission_handler.dart';
import 'package:provider/provider.dart';

import 'dialog_manager.dart';

class SilentDialogManager {
  static Future<bool> show(BuildContext context) async {
    bool isClose = false;
    bool isChecked = false;

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
                    style: const TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "再生中に音を鳴らしたくない場合",
                    style: const TextStyle(fontSize: 14),
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
                      style: const TextStyle(fontSize: 14),
                    ),
                    contentPadding: const EdgeInsets.all(0),
                    value: isChecked,
                    onChanged: (value) => setState(() {
                      isChecked = value;
                    }),
                  ),
                ],
              ),
              contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 2),
              actions: [
                DialogTextButton(
                  "設定を開く",
                  onPressed: () {
                    isClose = true;
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
    final prefs = await SharedPreferences.getInstance();
    if (isChecked && !isClose) prefs.setBool("isSilentHintVisible", false);
    return isClose;
  }
}
