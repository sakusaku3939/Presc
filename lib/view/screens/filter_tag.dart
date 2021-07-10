import 'package:flutter/material.dart';
import 'package:presc/view/utils/script_card.dart';

class FilterTagScreen extends StatelessWidget {
  FilterTagScreen(this.tag);

  final String tag;

  @override
  Widget build(BuildContext context) {
    List<Widget> _itemList = List.generate(
      4,
      (key) => Container(
        height: 280,
        margin: const EdgeInsets.fromLTRB(16, 4, 16, 16),
        child: ScriptCard(key.toString()),
      ),
    );

    return Scaffold(
      appBar: AppBar(),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 16),
            child: Column(
              children: _itemList,
            ),
          ),
        ),
      ),
    );
  }
}
