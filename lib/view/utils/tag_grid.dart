import 'package:flutter/material.dart';
import 'package:presc/model/utils/database_table.dart';
import 'package:presc/viewModel/manuscript_tag_provider.dart';
import 'package:provider/provider.dart';

class TagGrid extends StatelessWidget {
  TagGrid({this.memoId});

  final int memoId;

  @override
  Widget build(BuildContext context) {
    return Consumer<ManuscriptTagProvider>(
      builder: (context, model, child) {
        return Wrap(
          children: [
            for (var linkTagTable in model.linkTagTable)
              _tag(context, model, selected: true, tagTable: linkTagTable),
            for (var unlinkTagTable in model.unlinkTagTable)
              _tag(context, model, selected: false, tagTable: unlinkTagTable),
          ],
        );
      },
    );
  }

  Widget _tag(BuildContext context, ManuscriptTagProvider model,
      {bool selected, TagTable tagTable}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: selected ? Theme.of(context).accentColor : Colors.grey[300],
            width: 1,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        label: Text(tagTable.tagName),
        labelStyle: TextStyle(color: selected ? Colors.white : Colors.black),
        selectedColor: Theme.of(context).accentColor,
        backgroundColor: Colors.white,
        pressElevation: 2,
        selected: selected,
        onSelected: (value) async {
          model.changeChecked(
            memoId: memoId,
            tagId: tagTable.id,
            newValue: value,
          );
          Navigator.pop(context);
        },
      ),
    );
  }
}
