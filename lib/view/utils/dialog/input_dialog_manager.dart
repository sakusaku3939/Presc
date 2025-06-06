import 'package:flutter/material.dart';

import '../../../core/constants/color_constants.dart';
import 'dialog_manager.dart';

class InputDialogManager {
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String content,
    required String placeholder,
    required String okLabel,
    required String cancelLabel,
    required Function(String text) onOkPressed,
  }) async {
    final controller = TextEditingController.fromValue(
      TextEditingValue(
        text: content,
        selection: TextSelection.collapsed(
          offset: content.length,
        ),
      ),
    );
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
                  color: ColorConstants.mainColor,
                ),
              ),
            ),
            controller: controller,
            autofocus: true,
            cursorColor: ColorConstants.mainColor,
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
