import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:presc/features/manuscript/ui/pages/manuscript_search_page.dart';
import 'package:presc/features/manuscript/ui/providers/manuscript_provider.dart';
import 'package:provider/provider.dart';

import 'manuscript_filter_page.dart';
import 'manuscript_home_page.dart';

class ManuscriptPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    KeyboardVisibilityController().onChange.listen((bool visible) {
      if (!visible) FocusManager.instance.primaryFocus?.unfocus();
    });
    return Selector<ManuscriptProvider, Current>(
      selector: (_, model) => model.current,
      builder: (context, current, child) {
        switch (current.state) {
          case ManuscriptState.home:
            return ManuscriptHomePage();

          case ManuscriptState.tag:
          case ManuscriptState.trash:
            return ManuscriptFilterPage(current.state);

          case ManuscriptState.search:
            return ManuscriptSearchPage();
        }
      },
    );
  }
}
