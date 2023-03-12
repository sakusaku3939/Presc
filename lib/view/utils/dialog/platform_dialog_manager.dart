import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../config/color_config.dart';
import 'dialog_manager.dart';

class PlatformDialogManager {
  static Future<void> showDeleteAlert(
    BuildContext context, {
    String? title,
    String? message,
    required String deleteLabel,
    required String cancelLabel,
    required VoidCallback onDeletePressed,
  }) async {
    Text? text(String? t, {TextStyle? style}) {
      return t != null ? Text(t, style: style) : null;
    }

    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          title: text(title),
          message: text(message),
          actions: [
            CupertinoActionSheetAction(
              child: Text(
                deleteLabel,
                style: TextStyle(fontSize: 18),
              ),
              isDestructiveAction: true,
              onPressed: () {
                onDeletePressed();
                Navigator.pop(context);
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text(
              cancelLabel,
              style: TextStyle(
                color: ColorConfig.iosSystemBlue,
                fontSize: 18,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      );
    } else {
      DialogManager.show(
        context,
        title: text(title, style: TextStyle(fontSize: 20)),
        content: text(message),
        actions: [
          DialogTextButton(
            cancelLabel,
            onPressed: () => Navigator.pop(context),
          ),
          DialogTextButton(
            deleteLabel,
            onPressed: () {
              onDeletePressed();
              Navigator.pop(context);
            },
          ),
        ],
      );
    }
  }
}
