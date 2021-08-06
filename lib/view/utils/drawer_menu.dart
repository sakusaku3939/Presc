import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:presc/view/screens/setting.dart';
import 'package:presc/view/screens/tag_edit.dart';
import 'package:presc/view/utils/add_new_tag.dart';
import 'package:presc/viewModel/editable_tag_item_provider.dart';
import 'package:presc/viewModel/manuscript_provider.dart';
import 'package:provider/provider.dart';

class DrawerMenu extends StatelessWidget {
  DrawerMenu(this._scaffoldKey);

  final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Drawer(
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
              Consumer<ManuscriptProvider>(
                builder: (context, model, child) {
                  return ListTile(
                    leading: Icon(Icons.delete_outline),
                    title: Text('ごみ箱', style: TextStyle(fontSize: 14)),
                    dense: true,
                    onTap: () {
                      model.replaceState(ManuscriptState.trash);
                      _scaffoldKey.currentState.openEndDrawer();
                    },
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('設定', style: TextStyle(fontSize: 14)),
                dense: true,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tagList(BuildContext context) {
    return Consumer<EditableTagItemProvider>(
      builder: (context, model, child) {
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
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: TextButton(
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(Colors.black12),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                        ),
                        minimumSize: MaterialStateProperty.all(Size.zero),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        model.loadTag();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TagEditScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "編集",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            for (var allTagTable in model.allTagTable)
              ListTile(
                leading: Icon(Icons.tag),
                title:
                    Text(allTagTable.tagName, style: TextStyle(fontSize: 14)),
                dense: true,
                onLongPress: () {
                  model.loadTag();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TagEditScreen(),
                    ),
                  );
                },
                onTap: () {
                  context.read<ManuscriptProvider>().replaceState(
                        ManuscriptState.tag,
                        tagId: allTagTable.id,
                        tagName: allTagTable.tagName,
                      );
                  _scaffoldKey.currentState.openEndDrawer();
                },
              ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  Icon(Icons.add, color: Colors.black45),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 32, right: 16),
                      child: AddNewTag(fontSize: 14),
                    ),
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
