import 'package:flutter/material.dart';

class ScriptModalBottomSheet {
  void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return _sheet(context);
      },
    );
  }

  Widget _sheet(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.play_arrow_outlined),
          title: Text('原稿を再生'),
          onTap: () => {},
        ),
        ListTile(
          leading: Icon(Icons.delete_outline),
          title: Text('ごみ箱に移動'),
          onTap: () => {},
        ),
      ],
      ),
    );
  }
}
