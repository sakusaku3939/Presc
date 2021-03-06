import 'package:flutter/material.dart';
import 'package:presc/config/color_config.dart';
import 'package:presc/generated/l10n.dart';
import 'package:presc/model/utils/database_table.dart';
import 'package:presc/view/utils/dialog/platform_dialog_manager.dart';
import 'package:presc/view/utils/popup_menu.dart';
import 'package:presc/view/utils/ripple_button.dart';
import 'package:presc/view/utils/script_card.dart';
import 'package:presc/viewModel/editable_tag_item_provider.dart';
import 'package:presc/viewModel/manuscript_provider.dart';
import 'package:provider/provider.dart';

class ManuscriptFilterScreen extends StatelessWidget {
  ManuscriptFilterScreen(this.state);

  final ManuscriptState state;

  void _back(BuildContext context) {
    context.read<ManuscriptProvider>().replaceState(ManuscriptState.home);
    ScaffoldMessenger.of(context).clearSnackBars();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _back(context);
        return Future.value(false);
      },
      child: Scaffold(
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
                        S.current.trashHint,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ScriptCard(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _appbar(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: RippleIconButton(
        Icons.navigate_before,
        size: 32,
        onPressed: () => _back(context),
      ),
      title: Selector<ManuscriptProvider, TagTable>(
        selector: (_, model) => model.currentTagTable,
        builder: (context, currentTagTable, child) {
          return Text(
            state == ManuscriptState.tag
                ? currentTagTable.tagName
                : S.current.trash,
            style: const TextStyle(fontSize: 20),
          );
        },
      ),
      actions: [
        state == ManuscriptState.tag
            ? _tagActionsIcon(context)
            : _trashActionsIcon(context)
      ],
    );
  }

  Widget _tagActionsIcon(BuildContext context) {
    final tagItemProvider = context.read<EditableTagItemProvider>();
    return Consumer<ManuscriptProvider>(
      builder: (context, model, child) {
        return PopupMenu(
          [
            PopupMenuItem(
              child: Text(S.current.changeTagName),
              value: "change",
            ),
            PopupMenuItem(
              child: Text(S.current.removeTag),
              value: "delete",
            ),
          ],
          icon: Icon(Icons.more_vert, color: ColorConfig.iconColor),
          onSelected: (value) async {
            switch (value) {
              case "change":
                PlatformDialogManager.showInputDialog(
                  context,
                  title: S.current.tag,
                  content: model.currentTagTable.tagName,
                  placeholder: S.current.placeholderTagName,
                  okLabel: S.current.change,
                  cancelLabel: S.current.cancel,
                  onOkPressed: (String text) async {
                    if (text.trim().isNotEmpty) {
                      await tagItemProvider.updateTag(
                        model.currentTagTable.id,
                        text,
                      );
                      model.currentTagTable = TagTable(
                        id: model.currentTagTable.id,
                        tagName: text,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(S.current.tagUpdated),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                );
                break;
              case "delete":
                PlatformDialogManager.showDeleteAlert(
                  context,
                  message: S.current.alertRemoveTag(
                    model.currentTagTable.tagName,
                  ),
                  deleteLabel: S.current.remove,
                  cancelLabel: S.current.cancel,
                  onDeletePressed: () {
                    tagItemProvider.deleteTag(model.currentTagTable.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(S.current.tagRemoved),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                    model.replaceState(ManuscriptState.home);
                  },
                );
                break;
            }
          },
        );
      },
    );
  }

  Widget _trashActionsIcon(BuildContext context) {
    return RippleIconButton(
      Icons.clear_all,
      onPressed: () {
        PlatformDialogManager.showDeleteAlert(
          context,
          message: S.current.doEmptyTrash,
          deleteLabel: S.current.deleteAll,
          cancelLabel: S.current.cancel,
          onDeletePressed: () async {
            final provider = context.read<ManuscriptProvider>();
            await provider.clearTrash();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(S.current.trashEmptied),
                duration: const Duration(seconds: 2),
              ),
            );
            await provider.replaceState(state);
          },
        );
      },
    );
  }
}
