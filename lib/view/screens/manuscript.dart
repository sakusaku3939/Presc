import 'package:flutter/material.dart';
import 'package:presc/viewModel/manuscript_provider.dart';
import 'package:provider/provider.dart';

import 'manuscript_filter.dart';
import 'manuscript_home.dart';

class ManuscriptScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<ManuscriptProvider, int>(
      selector: (_, model) => model.state,
      builder: (context, state, child) {
        return state == ManuscriptState.home
            ? ManuscriptHomeScreen()
            : ManuscriptFilterScreen(state);
      },
    );
  }
}
