import 'package:flutter/material.dart';
import 'package:presc/view/utils/script_card.dart';

class FilterTagScreen extends StatelessWidget {
  FilterTagScreen(this.tag);

  final String tag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: cardPageView(key: tag, marginTop: 20)
        ),
      ),
    );
  }
}
