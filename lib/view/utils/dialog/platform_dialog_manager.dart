import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dialog_manager.dart';

class PlatformDialogManager {
  static Future<void> showDeleteAlert(
    BuildContext context, {
    String title,
    String message,
    @required String deleteLabel,
    @required String cancelLabel,
    @required VoidCallback onDeletePressed,
  }) async {
    final text = (String t) => t != null ? Text(t) : null;
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
                fontSize: 18,
                fontWeight: FontWeight.bold,
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
        title: text(title),
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

  static Future<void> showInputDialog(
    BuildContext context, {
    @required String title,
    @required String content,
    @required String placeholder,
    @required String okLabel,
    @required String cancelLabel,
    @required Function(String text) onOkPressed,
  }) async {
    final text = (String t) => t != null ? Text(t) : null;
    final controller = TextEditingController.fromValue(
      TextEditingValue(
        text: content,
        selection: TextSelection.collapsed(
          offset: content.length,
        ),
      ),
    );
    if (Platform.isIOS) {
      showCupertinoDialog<void>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8),
              CupertinoTextField(
                controller: controller,
                autofocus: true,
                cursorColor: Theme.of(context).accentColor,
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              child: Text(cancelLabel),
              onPressed: () => Navigator.pop(context),
            ),
            CupertinoDialogAction(
              child: Text(okLabel),
              onPressed: () {
                onOkPressed(controller.text);
                Navigator.pop(context);
              },
            )
          ],
        ),
      );
    } else {
      DialogManager.show(
        context,
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: placeholder,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
              controller: controller,
              autofocus: true,
              cursorColor: Theme.of(context).accentColor,
            ),
          ],
        ),
        actions: [
          DialogTextButton(
            cancelLabel,
            onPressed: () => Navigator.pop(context),
          ),
          DialogTextButton(
            okLabel,
            onPressed: () {
              onOkPressed(controller.text);
              Navigator.pop(context);
            },
          ),
        ],
      );
    }
  }
}
