import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:presc/generated/l10n.dart';

import '../../../../core/constants/color_constants.dart';

class ColorDialog {
  static void show(
    BuildContext context, {
    required Color pickerColor,
    required Color initialColor,
    required void Function(Color) onSubmitted,
  }) {
    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: ColorPicker(
                  pickerColor: pickerColor,
                  onColorChanged: (color) => pickerColor = color,
                  pickerAreaHeightPercent: 0.8,
                ),
              ),
              contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              actions: [
                TextButton(
                  child: Text(
                    S.current.resetInitValue,
                    style: TextStyle(color: ColorConstants.buttonLabelColor),
                  ),
                  onPressed: () => setState(() {
                    pickerColor = initialColor;
                  }),
                ),
                TextButton(
                  child: Text(
                    S.current.done,
                    style: TextStyle(color: ColorConstants.buttonLabelColor),
                  ),
                  onPressed: () {
                    onSubmitted(pickerColor);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
