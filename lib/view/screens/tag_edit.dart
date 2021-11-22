import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:presc/generated/l10n.dart';
import 'package:presc/model/utils/database_table.dart';
import 'package:presc/view/utils/add_new_tag.dart';
import 'package:presc/view/utils/dialog/dialog_manager.dart';
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
              child: Selector<EditableTagItemProvider, List<TagTable>>(
                selector: (_, model) => model.allTagTable,
                builder: (context, allTagTable, child) {
                  return Column(
                    children: [
                      for (var i = 0; i < allTagTable.length; i++)
                        EditableTagItem(i, allTagTable[i]),
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
              child: Selector<EditableTagItemProvider, bool>(
                selector: (_, model) => model.isDeleteSelectionMode,
                builder: (context, isDeleteSelectionMode, child) {
                  return isDeleteSelectionMode
                      ? Text(
                          S.current.addedNewTag,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black.withOpacity(0.6),
                          ),
                        )
                      : AddNewTag();
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
              S.current.editTag,
              style: const TextStyle(fontSize: 20),
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
              S.current.removeTag,
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 4),
                child: RippleIconButton(
                  Icons.delete_outlined,
                  color: Colors.white,
                  onPressed: () {
                    final count = model.checkList.where((e) => e).length;
                    if (count > 0)
                      DialogManager.show(
                        context,
                        contentPadding:
                            const EdgeInsets.fromLTRB(24, 20, 24, 24),
                        title: Text(S.current.removeTags(count)),
                        content: Text(S.current.removeTagsAlert),
                        actions: [
                          DialogTextButton(
                            S.current.cancel,
                            onPressed: () => Navigator.pop(context),
                          ),
                          DialogTextButton(
                            S.current.remove,
                            onPressed: () {
                              for (var i = 0; i < model.checkList.length; i++) {
                                if (model.checkList[i])
                                  model.deleteTag(model.allTagTable[i].id);
                              }
                              Navigator.pop(context);
                              model.isDeleteSelectionMode = false;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(S.current.tagsRemoved(count)),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                  },
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
