import 'package:flutter/material.dart';
import 'package:presc/viewModel/manuscript_provider.dart';
import 'package:provider/provider.dart';

class DrawerMenu extends StatelessWidget {
  DrawerMenu(this._scaffoldKey);

  final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          children: <Widget>[
            Container(
              height: 80,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: Divider.createBorderSide(
                      context,
                      color: Colors.grey[300],
                    ),
                  ),
                ),
                margin: const EdgeInsets.only(bottom: 0),
                padding: const EdgeInsets.fromLTRB(16, 28, 16, 30),
                child: Image.asset(
                  'assets/images/logo.png',
                  alignment: Alignment.centerLeft,
                ),
              ),
            ),
            _tagList(context),
            Divider(color: Colors.grey[300], height: 24),
            ListTile(
              leading: Icon(Icons.delete_outline),
              title: Text('ごみ箱', style: TextStyle(fontSize: 14)),
              dense: true,
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('設定', style: TextStyle(fontSize: 14)),
              dense: true,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _tagList(BuildContext context) {
    final _tagList = ['宮沢賢治', '練習用'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 8, 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "タグ一覧",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.black12),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                  minimumSize: MaterialStateProperty.all(Size.zero),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {},
                child: Text(
                  "編集",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        for (var tag in _tagList)
          Consumer<ManuscriptProvider>(
            builder: (context, model, child) {
              return ListTile(
                leading: Icon(Icons.tag),
                title: Text(tag, style: TextStyle(fontSize: 14)),
                dense: true,
                onTap: () {
                  model.itemList = tag;
                  model.isVisibleSearchbar = false;
                  _scaffoldKey.currentState.openEndDrawer();
                },
              );
            },
          ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              Icon(Icons.add, color: Colors.black45),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 32),
                  child: TextField(
                    cursorColor: Colors.black45,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.go,
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(0),
                      hintStyle: TextStyle(fontSize: 14),
                      hintText: '新しいタグを追加',
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
