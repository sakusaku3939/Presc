import 'package:flutter/material.dart';

import 'dialog_manager.dart';

class RadioDialogManager {
  static void show(
    BuildContext context, {
    @required List<RadioDialogItem> itemList,
    @required groupValue,
    @required Function(dynamic value) onChanged,
  }) {
    DialogManager.show(
      context,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 12,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var item in itemList)
            RadioListTile(
              title: item.title != null ? Text(item.title) : null,
              subtitle: item.subtitle != null ? Text(item.subtitle) : null,
              groupValue: groupValue,
              value: item.value,
              onChanged: (value) {
                onChanged(value);
                Navigator.pop(context);
              },
            )
        ],
      ),
    );
  }
}

class RadioDialogItem {
  final String title;
  final String subtitle;
  final value;

  RadioDialogItem({
    this.title,
    this.subtitle,
    @required this.value,
  });
}
