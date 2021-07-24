import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:presc/view/utils/editable_tag_item.dart';
import 'package:presc/view/utils/ripple_button.dart';
import 'package:presc/viewModel/editable_tag_item_provider.dart';
import 'package:provider/provider.dart';

class TagEditScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _tagList = ['宮沢賢治', '練習用'];

    return KeyboardDismissOnTap(
      child: Scaffold(
        appBar: _TagEditScreenAppbar(),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (var i = 0; i < _tagList.length; i++)
                    EditableTagItem(i, _tagList[i]),
                  _addNewTag(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _addNewTag() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Row(
        children: [
          Icon(Icons.add, color: Colors.black45),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 32, right: 16),
              child: Selector<EditableTagItemProvider, bool>(
                selector: (_, model) => model.isDeleteSelectionMode,
                builder: (context, isDeleteSelectionMode, child) {
                  return isDeleteSelectionMode
                      ? Text(
                          '新しいタグを追加',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black.withOpacity(0.6),
                          ),
                        )
                      : TextField(
                          cursorColor: Colors.black45,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.go,
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(0),
                            hintStyle: TextStyle(fontSize: 16),
                            hintText: '新しいタグを追加',
                          ),
                        );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TagEditScreenAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<EditableTagItemProvider>(
      builder: (context, model, child) {
        return AnimatedCrossFade(
          firstChild: AppBar(
            elevation: 0,
            leading: RippleIconButton(
              Icons.navigate_before,
              size: 32,
              onPressed: () {
                model.isDeleteSelectionMode = false;
                Navigator.pop(context);
              },
            ),
            title: Text(
              "タグの編集",
              style: TextStyle(fontSize: 20),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 4),
                child: RippleIconButton(
                  Icons.delete_sweep_outlined,
                  onPressed: () => model.isDeleteSelectionMode = true,
                ),
              ),
            ],
          ),
          secondChild: AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).accentColor,
            leading: RippleIconButton(
              Icons.clear,
              color: Colors.white,
              onPressed: () => model.isDeleteSelectionMode = false,
            ),
            title: Text(
              "タグを削除",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 4),
                child: RippleIconButton(
                  Icons.delete_outlined,
                  color: Colors.white,
                  onPressed: () => {},
                ),
              ),
            ],
          ),
          duration: const Duration(milliseconds: 150),
          crossFadeState: model.isDeleteSelectionMode
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
        );
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
