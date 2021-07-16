import 'package:flutter/material.dart';
import 'package:presc/view/utils/ripple_button.dart';
import 'package:presc/view/utils/script_card.dart';
import 'package:presc/viewModel/manuscript_provider.dart';
import 'package:provider/provider.dart';

class ManuscriptFilterScreen extends StatelessWidget {
  ManuscriptFilterScreen(this.state);

  final int state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(state),
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state == ManuscriptState.trash)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                    child: Text(
                      "ごみ箱の中身は7日以内に完全に削除されます",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                cardPageView()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appbar(int state) {
    return AppBar(
      elevation: 0,
      leading: Consumer<ManuscriptProvider>(
        builder: (context, model, child) {
          return RippleIconButton(
            Icons.navigate_before,
            size: 32,
            onPressed: () {
              model.itemList = '';
              model.state = ManuscriptState.home;
            },
          );
        },
      ),
      title: Consumer<ManuscriptProvider>(
        builder: (context, model, child) {
          return Text(
            state == ManuscriptState.tag ? model.currentTag : "ごみ箱",
            style: TextStyle(fontSize: 20),
          );
        },
      ),
      actions: [
        state == ManuscriptState.tag ? _tagActionsIcon() : _trashActionsIcon()
      ],
    );
  }

  Widget _tagActionsIcon() {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipOval(
        child: Material(
          type: MaterialType.transparency,
          child: PopupMenuButton<String>(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text("タグ名を変更"),
                value: "タグ名を変更",
              ),
              PopupMenuItem(
                child: Text("タグを削除"),
                value: "タグを削除",
              ),
            ],
            onSelected: (value) {},
          ),
        ),
      ),
    );
  }

  Widget _trashActionsIcon() {
    return RippleIconButton(
      Icons.clear_all,
      onPressed: () => {},
    );
  }
}
