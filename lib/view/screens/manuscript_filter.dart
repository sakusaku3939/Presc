import 'package:flutter/material.dart';
import 'package:presc/model/utils/database_table.dart';
import 'package:presc/view/utils/dialog_manager.dart';
import 'package:presc/view/utils/popup_menu.dart';
import 'package:presc/view/utils/ripple_button.dart';
import 'package:presc/view/utils/script_card.dart';
import 'package:presc/viewModel/editable_tag_item_provider.dart';
import 'package:presc/viewModel/manuscript_provider.dart';
import 'package:provider/provider.dart';

class ManuscriptFilterScreen extends StatelessWidget {
  ManuscriptFilterScreen(this.state);

  final ManuscriptState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(context),
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
                ScriptCard(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appbar(BuildContext context) {
    final currentTagTable = context.read<ManuscriptProvider>().currentTagTable;
    return AppBar(
      elevation: 0,
      leading: Consumer<ManuscriptProvider>(
        builder: (context, model, child) {
          return RippleIconButton(
            Icons.navigate_before,
            size: 32,
            onPressed: () {
              model.replaceState(ManuscriptState.home);
              ScaffoldMessenger.of(context).clearSnackBars();
            },
          );
        },
      ),
      title: Text(
        state == ManuscriptState.tag ? currentTagTable.tagName : "ごみ箱",
        style: TextStyle(fontSize: 20),
      ),
      actions: [
        state == ManuscriptState.tag
            ? _tagActionsIcon(context, currentTagTable)
            : _trashActionsIcon(context)
      ],
    );
  }

  Widget _tagActionsIcon(BuildContext context, TagTable currentTagTable) {
    return PopupMenu(
      [
        PopupMenuItem(
          child: Text("タグ名を変更"),
          value: "change",
        ),
        PopupMenuItem(
          child: Text("タグを削除"),
          value: "delete",
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case "change":
            break;
          case "delete":
            DialogManager.show(
              context,
              content: Text(
                "タグ ${currentTagTable.tagName}を削除しますか？この操作は元に戻せません。",
              ),
              actions: [
                DialogTextButton(
                  "キャンセル",
                  onPressed: () => Navigator.pop(context),
                ),
                DialogTextButton(
                  "削除",
                  onPressed: () async {
                    context
                        .read<EditableTagItemProvider>()
                        .deleteTag(currentTagTable.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "タグを削除しました",
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                    Navigator.pop(context);
                    context
                        .read<ManuscriptProvider>()
                        .replaceState(ManuscriptState.home);
                  },
                ),
              ],
            );
            break;
        }
      },
    );
  }

  Widget _trashActionsIcon(BuildContext context) {
    return RippleIconButton(
      Icons.clear_all,
      onPressed: () {
        DialogManager.show(
          context,
          content: Text("ごみ箱の中身を空にしますか？"),
          actions: [
            DialogTextButton(
              "キャンセル",
              onPressed: () => Navigator.pop(context),
            ),
            DialogTextButton(
              "全て削除",
              onPressed: () async {
                final provider = context.read<ManuscriptProvider>();
                await provider.clearTrash();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "ごみ箱を空にしました",
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
                await provider.replaceState(state);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
