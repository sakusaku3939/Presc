import 'package:flutter/material.dart';
import 'package:presc/viewModel/editable_tag_item_provider.dart';
import 'package:provider/provider.dart';

class EditableTagItem extends StatelessWidget {
  const EditableTagItem(this.index, this.tag);

  final int index;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return Selector<EditableTagItemProvider, bool>(
      selector: (_, model) => model.isDeleteSelectionMode,
      builder: (context, isDeleteSelectionMode, child) {
        return isDeleteSelectionMode ? _checkboxList(context) : _tagList();
      },
    );
  }

  Widget _tagList() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Row(
        children: [
          Icon(Icons.tag, color: Colors.black45),
          SizedBox(width: 32),
          Expanded(
            child: TextField(
              cursorColor: Colors.black45,
              controller: TextEditingController.fromValue(
                TextEditingValue(
                  text: tag,
                  selection: TextSelection.collapsed(offset: tag.length),
                ),
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.go,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(0),
              ),
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _checkboxList(BuildContext context) {
    return Consumer<EditableTagItemProvider>(
      builder: (context, model, child) {
        return Container(
          color: model.checkedList[index]
              ? Theme.of(context).accentColor.withOpacity(.1)
              : Colors.white,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => model.toggleChecked(index),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Transform.scale(
                        scale: 1.1,
                        child: Checkbox(
                          shape: CircleBorder(),
                          value: model.checkedList[index],
                          activeColor: Theme.of(context).accentColor,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          onChanged: (bool value) => model.toggleChecked(index),
                        ),
                      ),
                    ),
                    SizedBox(width: 32),
                    Expanded(
                      child: Text(
                        tag,
                        style: TextStyle(fontSize: 16),
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
