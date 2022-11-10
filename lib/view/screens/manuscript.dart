import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:presc/view/screens/manuscript_search.dart';
import 'package:presc/viewModel/manuscript_provider.dart';
import 'package:provider/provider.dart';

import 'manuscript_filter.dart';
import 'manuscript_home.dart';

class ManuscriptScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    KeyboardVisibilityController().onChange.listen((bool visible) {
      if (!visible) FocusManager.instance.primaryFocus?.unfocus();
    });
    return Selector<ManuscriptProvider, ManuscriptState>(
      selector: (_, model) => model.state,
      builder: (context, state, child) {
        switch (state) {
          case ManuscriptState.home:
            return ManuscriptHomeScreen();
            break;
          case ManuscriptState.tag:
          case ManuscriptState.trash:
            return ManuscriptFilterScreen(state);
            break;
          case ManuscriptState.search:
            return ManuscriptSearchScreen();
            break;
          default:
            return Container();
            break;
        }
      },
    );
  }
}
