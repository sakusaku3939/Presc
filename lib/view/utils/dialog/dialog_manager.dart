import 'package:flutter/material.dart';

class DialogManager {
  static void show(
    BuildContext context, {
    Widget? title,
    Widget? content,
    EdgeInsetsGeometry contentPadding =
        const EdgeInsets.fromLTRB(24, 32, 24, 16),
    List<Widget>? actions,
  }) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          surfaceTintColor: Colors.transparent,
          title: title,
          content: content,
          contentPadding: contentPadding,
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
      child: Text(text, style: TextStyle(color: Theme.of(context).accentColor)),
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
