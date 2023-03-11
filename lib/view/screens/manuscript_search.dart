import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:presc/generated/l10n.dart';
import 'package:presc/view/utils/ripple_button.dart';
import 'package:presc/view/utils/script/script_card.dart';
import 'package:presc/viewModel/manuscript_provider.dart';
import 'package:provider/provider.dart';

class ManuscriptSearchScreen extends StatelessWidget {
  void _back(BuildContext context) {
    final script = context.read<ManuscriptProvider>();
    script.replaceState(ManuscriptState.home);
    ScaffoldMessenger.of(context).clearSnackBars();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _back(context);
        return Future.value(false);
      },
      child: KeyboardDismissOnTap(
        child: Scaffold(
          appBar: _appbar(context),
          body: SafeArea(
            child: Scrollbar(
              child: SingleChildScrollView(
                child: ScriptCard(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _appbar(BuildContext context) {
    Timer? _timer;
    return AppBar(
      elevation: 1,
      leading: RippleIconButton(
        Icons.navigate_before,
        size: 32,
        onPressed: () => _back(context),
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
          hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
          hintText: S.current.searchScript,
        ),
        onChanged: (text) async {
          _timer?.cancel();
          _timer = Timer(
            Duration(milliseconds: 200),
            () => context
                .read<ManuscriptProvider>()
                .replaceState(ManuscriptState.search, searchWord: text),
          );
        },
      ),
    );
  }
}
