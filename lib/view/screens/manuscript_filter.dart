import 'package:flutter/material.dart';
import 'package:presc/config/color_config.dart';
import 'package:presc/generated/l10n.dart';
import 'package:presc/model/utils/database_table.dart';
import 'package:presc/view/utils/dialog/dialog_manager.dart';
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
          onSelected: (value) {
            switch (value) {
              case "change":
                final controller = TextEditingController.fromValue(
                  TextEditingValue(
                    text: model.currentTagTable.tagName,
                    selection: TextSelection.collapsed(
                      offset: model.currentTagTable.tagName.length,
                    ),
                  ),
                );
                DialogManager.show(
                  context,
                  contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        S.current.tag,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: S.current.placeholderTagName,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                        controller: controller,
                        autofocus: true,
                        cursorColor: Theme.of(context).accentColor,
                      ),
                    ],
                  ),
                  actions: [
                    DialogTextButton(
                      S.current.cancel,
                      onPressed: () => Navigator.pop(context),
                    ),
                    DialogTextButton(
                      S.current.change,
                      onPressed: () async {
                        final text = controller.text;
                        if (text.trim().isNotEmpty) {
                          await tagItemProvider.updateTag(
                            model.currentTagTable.id,
                            text,
                          );
                          model.currentTagTable = TagTable(
                            id: model.currentTagTable.id,
                            tagName: text,
                          );
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(S.current.updatedTags),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                );
                break;
              case "delete":
                DialogManager.show(
                  context,
                  content: Text(
                    S.current.removeTagAlert(model.currentTagTable.tagName),
                  ),
                  actions: [
                    DialogTextButton(
                      S.current.cancel,
                      onPressed: () => Navigator.pop(context),
                    ),
                    DialogTextButton(
                      S.current.remove,
                      onPressed: () async {
                        tagItemProvider.deleteTag(model.currentTagTable.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(S.current.tagRemoved),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                        Navigator.pop(context);
                        model.replaceState(ManuscriptState.home);
                      },
                    ),
                  ],
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
        DialogManager.show(
          context,
          content: Text(S.current.isEmptyTrash),
          actions: [
            DialogTextButton(
              S.current.cancel,
              onPressed: () => Navigator.pop(context),
            ),
            DialogTextButton(
              S.current.deleteAll,
              onPressed: () async {
                final provider = context.read<ManuscriptProvider>();
                await provider.clearTrash();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(S.current.emptiedTrash),
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
