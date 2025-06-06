import 'package:flutter/material.dart';
import 'package:presc/core/constants/color_constants.dart';
import 'package:presc/generated/l10n.dart';
import 'package:presc/model/utils/database_table.dart';
import 'package:presc/features/manuscript/ui/widgets/input_dialog.dart';
import 'package:presc/shared/widgets/dialog/platform_dialog.dart';
import 'package:presc/view/utils/popup_menu.dart';
import 'package:presc/view/utils/ripple_button.dart';
import 'package:presc/features/manuscript/ui/widgets/script_card.dart';
import 'package:presc/features/tag/ui/providers/editable_tag_item_provider.dart';
import 'package:presc/features/manuscript/ui/providers/manuscript_provider.dart';
import 'package:provider/provider.dart';

class ManuscriptFilterPage extends StatelessWidget {
  ManuscriptFilterPage(this.state);

  final ManuscriptState state;

  void _back(BuildContext context) {
    final script = context.read<ManuscriptProvider>();
    script.replaceState(ManuscriptState.home);
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

  AppBar _appbar(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: RippleIconButton(
        Icons.navigate_before,
        size: 32,
        onPressed: () => _back(context),
      ),
      title: Selector<ManuscriptProvider, Current>(
        selector: (_, model) => model.current,
        builder: (context, current, child) {
          return Selector<EditableTagItemProvider, TagTable?>(
              selector: (_, model) =>
                  model.allTagTable.isNotEmpty && current.tagTable != null
                      ? model.getTag(current.tagTable!.id)
                      : null,
              builder: (context, tagTable, child) {
                return Text(
                  state == ManuscriptState.tag
                      ? tagTable?.tagName ?? current.tagTable?.tagName ?? ""
                      : S.current.trash,
                  style: const TextStyle(fontSize: 20),
                );
              });
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
    final tagItem = context.read<EditableTagItemProvider>();
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
          icon: Icon(Icons.more_vert, color: ColorConstants.iconColor),
          onSelected: (value) async {
            if (model.current.tagTable == null) return;

            switch (value) {
              case "change":
                InputDialog.show(
                  context,
                  title: S.current.tag,
                  content: model.current.tagTable!.tagName,
                  placeholder: S.current.placeholderTagName,
                  okLabel: S.current.change,
                  cancelLabel: S.current.cancel,
                  onOkPressed: (String text) async {
                    if (text.trim().isNotEmpty) {
                      await tagItem.updateTag(
                        model.current.tagTable!.id,
                        text,
                      );
                      model.current.tagTable = TagTable(
                        id: model.current.tagTable!.id,
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
                PlatformDialog.showDeleteAlert(
                  context,
                  message: S.current.alertRemoveTag(
                    model.current.tagTable!.tagName,
                  ),
                  deleteLabel: S.current.remove,
                  cancelLabel: S.current.cancel,
                  onDeletePressed: () {
                    tagItem.deleteTag(model.current.tagTable!.id);
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
        PlatformDialog.showDeleteAlert(
          context,
          message: S.current.doEmptyTrash,
          deleteLabel: S.current.deleteAll,
          cancelLabel: S.current.cancel,
          onDeletePressed: () async {
            final script = context.read<ManuscriptProvider>();
            await script.clearTrash();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(S.current.trashEmptied),
                duration: const Duration(seconds: 2),
              ),
            );
            await script.replaceState(state);
          },
        );
      },
    );
  }
}
