import 'package:flutter/material.dart';
import 'package:presc/generated/l10n.dart';
import 'package:presc/model/locale_image.dart';
import 'package:presc/viewModel/playback_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sound_mode/permission_handler.dart';

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
                    S.current.hint + ":",
                    style: const TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    S.current.hintContent,
                    style: const TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 12),
                  LocaleImage.asset(
                    'assets/images/screenshot/silent_mode.png',
                  ),
                  SizedBox(height: 12),
                  CheckboxListTile(
                    dense: true,
                    title: Text(
                      S.current.notShowAgain,
                      style: const TextStyle(fontSize: 14),
                    ),
                    contentPadding: const EdgeInsets.all(0),
                    value: isChecked,
                    onChanged: (value) => setState(() {
                      if (value != null) isChecked = value;
                    }),
                  ),
                ],
              ),
              contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 2),
              actions: [
                DialogTextButton(
                  S.current.openSetting,
                  onPressed: () {
                    final playback = context.read<PlaybackProvider>();
                    isClose = true;
                    playback.playFabState = false;

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
