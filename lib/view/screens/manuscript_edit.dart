import 'package:flutter/material.dart';
import 'package:presc/model/utils/database_table.dart';
import 'package:presc/view/screens/playback.dart';
import 'package:presc/view/utils/dialog_manager.dart';
import 'package:presc/view/utils/popup_menu.dart';
import 'package:presc/view/utils/ripple_button.dart';
import 'package:presc/view/utils/trash_move_manager.dart';
import 'package:presc/viewModel/manuscript_provider.dart';
import 'package:presc/viewModel/manuscript_tag_provider.dart';
import 'package:provider/provider.dart';

class ManuscriptEditScreen extends StatelessWidget {
  ManuscriptEditScreen(this.context, this.heroTag, this.index);

  final BuildContext context;
  final String heroTag;
  final int index;

  ManuscriptProvider get _provider => context.read<ManuscriptProvider>();

  int get id => _provider.scriptTable[index].id;

  String get title => _provider.scriptTable[index].title;

  String get content => _provider.scriptTable[index].content;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _provider.notifyBack(context);
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Hero(
          tag: heroTag,
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Container(child: _menuBar(context)),
                  Expanded(
                    child: SingleChildScrollView(
                      child: _provider.state != ManuscriptState.trash
                          ? _editableContent(context)
                          : _uneditableContent(context),
                    ),
                  ),
                  Container(child: _footer(context)),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: SafeArea(
          child: FloatingActionButton(
            onPressed: () => {
              if (_provider.state != ManuscriptState.trash)
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PlaybackScreen()),
                )
            },
            child: Icon(Icons.play_arrow),
          ),
        ),
      ),
    );
  }

  Widget _menuBar(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        color: Colors.white,
        height: 56,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RippleIconButton(
              Icons.navigate_before,
              size: 32,
              onPressed: () => _provider.notifyBack(context),
            ),
            _provider.state != ManuscriptState.trash
                ? _editStateMenu()
                : _trashStateMenu()
          ],
        ),
      ),
    );
  }

  Widget _editableContent(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            cursorColor: Colors.black45,
            controller: TextEditingController.fromValue(
              TextEditingValue(
                text: title,
                selection: TextSelection.collapsed(offset: title.length),
              ),
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.go,
            maxLines: null,
            decoration: InputDecoration(
              isDense: true,
              hintText: "タイトル",
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(0),
            ),
            style: TextStyle(fontSize: 24),
            onChanged: (text) => _provider.saveScript(id: id, title: text),
          ),
          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 32),
            child: TextField(
              cursorColor: Colors.black45,
              controller: TextEditingController.fromValue(
                TextEditingValue(
                  text: content,
                  selection: TextSelection.collapsed(offset: content.length),
                ),
              ),
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              maxLines: null,
              decoration: InputDecoration(
                isDense: true,
                hintText: "ここに原稿を入力",
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(0),
              ),
              style: TextStyle(
                color: Colors.grey[800],
                height: 1.7,
                fontSize: 16,
              ),
              onChanged: (text) => _provider.saveScript(id: id, content: text),
            ),
          ),
        ],
      ),
    );
  }

  Widget _uneditableContent(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 16),
          Text(
            content,
            style: TextStyle(
              color: Colors.grey[800],
              height: 1.7,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _footer(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.only(left: 16, right: 24),
      child: Row(
        children: [
          RippleIconButton(
            Icons.playlist_add,
            onPressed: () {
              if (_provider.state != ManuscriptState.trash) {
                context.read<ManuscriptTagProvider>().loadTag(memoId: id);
                final controller = TextEditingController();
                DialogManager.show(
                  context,
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          hintText: "新しいタグを追加",
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                        controller: controller,
                        cursorColor: Theme.of(context).accentColor,
                        onSubmitted: (text) {
                          if (text.trim().isNotEmpty) {
                            context
                                .read<ManuscriptTagProvider>()
                                .addTag(memoId: id, name: text);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "新しいタグを追加しました",
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                          controller.clear();
                        },
                      ),
                      SizedBox(height: 12),
                      _tagGrid(),
                    ],
                  ),
                );
              }
            },
          ),
          Expanded(
            child: ScrollConfiguration(
              behavior: ScrollBehavior(),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Consumer<ManuscriptTagProvider>(
                  builder: (context, model, child) {
                    return Row(
                      children: [
                        for (var linkTagTable in model.linkTagTable)
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Chip(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.grey[300], width: 1),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              deleteIcon: Icon(
                                Icons.cancel,
                                color: Colors.grey[700],
                                size: 18,
                              ),
                              label: Text(linkTagTable.tagName),
                              backgroundColor: Colors.transparent,
                              onDeleted: () => {
                                if (_provider.state != ManuscriptState.trash)
                                  model.changeChecked(
                                    memoId: id,
                                    tagId: linkTagTable.id,
                                    newValue: false,
                                  )
                              },
                            ),
                          ),
                        SizedBox(width: 56),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _editStateMenu() {
    return Row(
      children: [
        RippleIconButton(
          Icons.share,
          onPressed: () => {},
        ),
        RippleIconButton(
          Icons.delete_outline,
          onPressed: () async {
            Navigator.pop(context);
            await Future.delayed(Duration(milliseconds: 300));
            TrashMoveManager.move(
              context: context,
              provider: _provider,
              index: index,
            );
          },
        ),
        RippleIconButton(
          Icons.info_outline,
          onPressed: () => {},
        ),
      ],
    );
  }

  Widget _trashStateMenu() {
    return Row(
      children: [
        RippleIconButton(
          Icons.restore_outlined,
          onPressed: () async {
            Navigator.pop(context);
            await Future.delayed(Duration(milliseconds: 300));
            TrashMoveManager.restore(
              context: context,
              provider: _provider,
              index: index,
            );
          },
        ),
        PopupMenu(
          [
            PopupMenuItem(
              child: Text("完全に削除"),
              value: "delete",
            )
          ],
          onSelected: (_) async {
            Navigator.pop(context);
            await Future.delayed(Duration(milliseconds: 300));
            TrashMoveManager.delete(
              context: context,
              provider: _provider,
              index: index,
            );
          },
        ),
      ],
    );
  }

  Widget _tagGrid() {
    return Consumer<ManuscriptTagProvider>(
      builder: (context, model, child) {
        return Wrap(
          children: [
            for (var linkTagTable in model.linkTagTable)
              _tag(model, selected: true, tagTable: linkTagTable),
            for (var unlinkTagTable in model.unlinkTagTable)
              _tag(model, selected: false, tagTable: unlinkTagTable),
          ],
        );
      },
    );
  }

  Widget _tag(ManuscriptTagProvider model, {bool selected, TagTable tagTable}) {
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
        selectedColor: Theme.of(context).accentColor,
        backgroundColor: Colors.white,
        pressElevation: 2,
        selected: selected,
        onSelected: (value) async {
          model.changeChecked(
            memoId: id,
            tagId: tagTable.id,
            newValue: value,
          );
          Navigator.pop(context);
        },
      ),
    );
  }
}
