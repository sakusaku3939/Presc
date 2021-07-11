import 'package:flutter/material.dart';
import 'package:presc/view/utils/script_card.dart';

class FilterTagScreen extends StatelessWidget {
  FilterTagScreen(this.tag);

  final String tag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, tag),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: cardPageView(key: tag, marginTop: 16),
        ),
      ),
    );
  }

  Widget appBar(BuildContext context, String tag) {
    return AppBar(
      elevation: 0,
      title: Text(
        tag,
        style: TextStyle(fontSize: 20),
      ),
      leading: IconButton(
        icon: Icon(Icons.navigate_before),
        iconSize: 32,
        onPressed: () => {Navigator.pop(context)},
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.tune),
          onPressed: () => {},
        ),
      ],
    );
  }
}
