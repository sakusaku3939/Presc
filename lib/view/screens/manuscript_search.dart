import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:presc/view/utils/ripple_button.dart';

class ManuscriptSearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        appBar: _appbar(context),
        body: SafeArea(
          child: Container(),
        ),
      ),
    );
  }

  Widget _appbar(BuildContext context) {
    return AppBar(
      elevation: 1,
      leading: RippleIconButton(
        Icons.navigate_before,
        size: 32,
        onPressed: () => Navigator.pop(context),
      ),
      title: TextField(
        autofocus: true,
        cursorColor: Colors.black45,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.go,
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(0),
          hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
          hintText: '原稿を検索',
        ),
      ),
    );
  }
}
