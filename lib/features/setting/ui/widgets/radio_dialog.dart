import 'package:flutter/material.dart';
import 'package:presc/core/constants/color_constants.dart';

import '../../../../shared/widgets/dialog/app_dialog.dart';

class RadioDialog {
  static void show(
    BuildContext context, {
    required List<RadioDialogItem> itemList,
    required groupValue,
    required Function(dynamic value) onChanged,
  }) {
    AppDialog.show(
      context,
      contentPadding: const EdgeInsets.symmetric(vertical: 12),
      content: RadioGroup<dynamic>(
        groupValue: groupValue,
        onChanged: (value) {
          onChanged(value);
          Navigator.pop(context);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var item in itemList)
              RadioListTile<dynamic>(
                title: item.title != null ? Text(item.title!) : null,
                subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
                activeColor: ColorConstants.mainColor,
                value: item.value,
              ),
          ],
        ),
      ),
    );
  }
}

class RadioDialogItem {
  final String? title;
  final String? subtitle;
  final value;

  RadioDialogItem({this.title, this.subtitle, required this.value});
}
