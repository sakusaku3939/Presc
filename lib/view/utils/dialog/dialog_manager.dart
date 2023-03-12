import 'package:flutter/material.dart';

import '../../../config/color_config.dart';

class DialogManager {
  static void show(
    BuildContext context, {
    Widget? title,
    Widget? content,
    EdgeInsetsGeometry? contentPadding,
    List<Widget>? actions,
  }) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: title,
          content: content,
          contentPadding: contentPadding ??
              EdgeInsets.fromLTRB(
                24,
                title == null ? 32 : 16,
                24,
                16,
              ),
          actions: actions,
        );
      },
    );
  }
}

class DialogTextButton extends StatelessWidget {
  DialogTextButton(this.text, {required this.onPressed});

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        text,
        style: TextStyle(color: ColorConfig.mainColor),
      ),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
        ),
        minimumSize: MaterialStateProperty.all(Size.zero),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: onPressed,
    );
  }
}
