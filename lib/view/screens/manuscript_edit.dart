import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import 'package:presc/config/color_config.dart';
import 'package:presc/model/char_counter.dart';
import 'package:presc/view/screens/playback.dart';
import 'package:presc/view/utils/dialog/dialog_manager.dart';
import 'package:presc/view/utils/popup_menu.dart';
import 'package:presc/view/utils/ripple_button.dart';
import 'package:presc/view/utils/tag_grid.dart';
import 'package:presc/view/utils/trash_move_manager.dart';
import 'package:presc/viewModel/manuscript_provider.dart';
import 'package:presc/viewModel/manuscript_tag_provider.dart';
import 'package:provider/provider.dart';

class ManuscriptEditScreen extends StatelessWidget {
  ManuscriptEditScreen(this.context, this.index, {this.autofocus = false});

  final BuildContext context;
  final int index;
  final bool autofocus;

  ManuscriptProvider get _provider => context.read<ManuscriptProvider>();

  int get id => _provider.scriptTable[index].id;

  String get title => _provider.scriptTable[index].title;

  String get content => _provider.scriptTable[index].content;

  DateTime get date => _provider.scriptTable[index].date;

  Future<void> _back() async {
    await _provider.notifyBack(context);
    if (title.isEmpty && content.isEmpty) {
      await Future.delayed(Duration(milliseconds: 300));
      TrashMoveManager.deleteEmpty(
        context: context,
        provider: _provider,
        index: index,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _back();
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Hero(
          tag: id,
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
            onPressed: () async {
              if (_provider.state != ManuscriptState.trash) {
                await _provider.updateScriptTable();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PlaybackScreen(index)),
                );
              }
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
              onPressed: () async => await _back(),
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
            autofocus: autofocus,
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
                hintText: "ここに入力",
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(0),
              ),
              style: TextStyle(
                color: Colors.grey[800],
                height: 1.7,
                fontSize: 16,
              ),
              onChanged: (text) {
                _CurrentScript.content = text;
                _provider.saveScript(id: id, content: text);
              },
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
            title.isNotEmpty ? title : "タイトルなし",
            style: TextStyle(
              color: title.isNotEmpty ? null : Theme.of(context).hintColor,
              fontSize: 24,
            ),
          ),
          SizedBox(height: 16),
          Text(
            content.isNotEmpty ? content : "追加のテキストはありません",
            style: TextStyle(
              color: content.isNotEmpty
                  ? Colors.grey[800]
                  : Theme.of(context).hintColor,
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
                      TagGrid(memoId: id),
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
                                color: ColorConfig.iconColor,
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
          onPressed: () => {
            DialogManager.show(
              context,
              contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "文字数",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    CharCounter.includeSpace(_CurrentScript.content ?? content)
                        .toString(),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "空白を除いた文字数",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    CharCounter.ignoreSpace(_CurrentScript.content ?? content)
                        .toString(),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "最終更新日時",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    DateFormat('yyyy/MM/dd(E) HH:mm', "ja_JP").format(
                      _provider.scriptTable[index].date,
                    ),
                  ),
                ],
              ),
              actions: [
                DialogTextButton(
                  "戻る",
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            )
          },
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
}

class _CurrentScript {
  static String title;
  static String content;
}