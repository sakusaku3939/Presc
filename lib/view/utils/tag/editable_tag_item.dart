import 'package:flutter/material.dart';
import 'package:presc/config/color_config.dart';
import 'package:presc/generated/l10n.dart';
import 'package:presc/model/utils/database_table.dart';
import 'package:presc/viewModel/editable_tag_item_provider.dart';
import 'package:provider/provider.dart';

class EditableTagItem extends StatelessWidget {
  const EditableTagItem(this.index, this.tagTable);

  final int index;
  final TagTable tagTable;

  @override
  Widget build(BuildContext context) {
    return Selector<EditableTagItemProvider, bool>(
      selector: (_, model) => model.isDeleteSelectionMode,
      builder: (context, isDeleteSelectionMode, child) {
        return isDeleteSelectionMode
            ? _checkboxList(context)
            : _tagList(context);
      },
    );
  }

  Widget _tagList(BuildContext context) {
    final controller = TextEditingController.fromValue(
      TextEditingValue(
        text: tagTable.tagName,
        selection: TextSelection.collapsed(
          offset: tagTable.tagName.length,
        ),
      ),
    );
    return Material(
      color: Colors.transparent,
      child: Consumer<EditableTagItemProvider>(
        builder: (context, model, child) {
          return InkWell(
            onLongPress: () {
              model.isDeleteSelectionMode = true;
              model.checkList[index] = true;
            },
            child: child,
          );
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 4, 16),
          child: Row(
            children: [
              Icon(Icons.tag, color: Colors.black45),
              SizedBox(width: 32),
              Expanded(
                child: TextField(
                  cursorColor: Colors.black45,
                  controller: controller,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(0),
                  ),
                  style: const TextStyle(fontSize: 16),
                  onSubmitted: (text) {
                    if (text.trim().isNotEmpty) {
                      context
                          .read<EditableTagItemProvider>()
                          .updateTag(tagTable.id, text);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(S.current.tagUpdated),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    } else {
                      controller.text = tagTable.tagName;
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _checkboxList(BuildContext context) {
    return Consumer<EditableTagItemProvider>(
      builder: (context, model, child) {
        return Container(
          color: model.checkList[index]
              ? ColorConfig.mainColor.withOpacity(.1)
              : Colors.white,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => model.toggleChecked(index),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 4, 16),
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: model.checkList[index],
                        activeColor: ColorConfig.mainColor,
                        onChanged: (_) => model.toggleChecked(index),
                      ),
                    ),
                    SizedBox(width: 32),
                    Expanded(
                      child: Text(
                        tagTable.tagName,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
