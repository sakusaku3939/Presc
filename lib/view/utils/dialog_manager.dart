import 'package:flutter/material.dart';

class DialogManager {
  static void show(
    BuildContext context, {
    Widget title,
    Widget content,
    List<Widget> actions,
  }) {
    List<Widget> _adjustActions;
    if (actions != null) {
      _adjustActions = [
        actions,
        [SizedBox(width: 2)],
      ].expand((_) => _).toList();
    }
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: title,
          content: content,
          actions: _adjustActions,
        );
      },
    );
  }
}

class DialogTextButton extends StatelessWidget {
  DialogTextButton(this.text, {@required this.onPressed});

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(text),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(
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
