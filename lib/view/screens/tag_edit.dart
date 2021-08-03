import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:presc/view/utils/editable_tag_item.dart';
import 'package:presc/view/utils/ripple_button.dart';
import 'package:presc/viewModel/editable_tag_item_provider.dart';
import 'package:provider/provider.dart';

class TagEditScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        appBar: _TagEditScreenAppbar(),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Consumer<EditableTagItemProvider>(
                builder: (context, model, child) {
                  return Column(
                    children: [
                      for (var i = 0; i < model.allTagTable.length; i++)
                        EditableTagItem(i, model.allTagTable[i]),
                      _addNewTag(),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _addNewTag() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 4, 16),
      child: Row(
        children: [
          Icon(Icons.add, color: Colors.black45),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 32, right: 16),
              child: Consumer<EditableTagItemProvider>(
                builder: (context, model, child) {
                  final controller = TextEditingController();
                  return model.isDeleteSelectionMode
                      ? Text(
                          '新しいタグを追加',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black.withOpacity(0.6),
                          ),
                        )
                      : TextField(
                          controller: controller,
                          cursorColor: Colors.black45,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(0),
                            hintStyle: TextStyle(fontSize: 16),
                            hintText: '新しいタグを追加',
                          ),
                          onSubmitted: (text) {
                            model.addTag(text);
                            controller.clear();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "新しいタグを追加しました",
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
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
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) {
                      final count = model.checkList.where((e) => e).length;
                      return AlertDialog(
                        title: Text("$count件のタグを削除"),
                        content: Text("選択したタグを全て削除しますか？この操作は復元できません。"),
                        actions: [
                          TextButton(
                            child: Text("キャンセル"),
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 8,
                                ),
                              ),
                              minimumSize: MaterialStateProperty.all(Size.zero),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          TextButton(
                            child: Text("削除"),
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 8,
                                ),
                              ),
                              minimumSize: MaterialStateProperty.all(Size.zero),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              for (var i = 0; i < model.checkList.length; i++) {
                                if (model.checkList[i])
                                  model.deleteTag(model.allTagTable[i].id);
                              }
                              Navigator.pop(context);
                              model.isDeleteSelectionMode = false;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "$count件のタグを削除しました",
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                          SizedBox(width: 2),
                        ],
                      );
                    },
                  ),
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
