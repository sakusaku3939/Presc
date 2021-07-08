import 'package:flutter/material.dart';

class ScriptModalBottomSheet {
  void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      backgroundColor: Colors.white,
      builder: (ctx) {
        return _sheet(context);
      },
    );
  }

  Widget _sheet(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 30,
            height: 4,
            margin: EdgeInsets.only(top: 6, bottom: 4),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              border: Border.all(color: Colors.grey[300]),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          ListTile(
            leading: Transform.translate(
              offset: Offset(8, 0),
              child: Icon(Icons.play_arrow_outlined),
            ),
            title: Text('原稿を再生'),
            onTap: () => {},
          ),
          ListTile(
            leading: Transform.translate(
              offset: Offset(8, 0),
              child: Icon(Icons.delete_outline),
            ),
            title: Text('ごみ箱に移動'),
            onTap: () => {},
          ),
        ],
      ),
    );
  }
}
