import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:presc/config/color_config.dart';
import 'package:presc/config/init_config.dart';
import 'package:presc/generated/l10n.dart';
import 'package:presc/model/char_counter.dart';
import 'package:presc/model/language.dart';
import 'package:presc/view/screens/playback.dart';
import 'package:presc/view/utils/dialog/dialog_manager.dart';
import 'package:presc/view/utils/popup_menu.dart';
import 'package:presc/view/utils/ripple_button.dart';
import 'package:presc/view/utils/tag/tag_grid.dart';
import 'package:presc/view/utils/trash_move_snackbar.dart';
import 'package:presc/viewModel/manuscript_provider.dart';
import 'package:presc/viewModel/manuscript_tag_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ManuscriptEditScreen extends StatelessWidget {
  ManuscriptEditScreen(this.context, this.index, {this.autofocus = false});

  final BuildContext context;
  final int index;
  final bool autofocus;
  final _current = _CurrentScript();

  ManuscriptProvider get _script => context.read<ManuscriptProvider>();

  int get id => _script.scriptTable[index].id;

  String get title => _script.scriptTable[index].title ?? "";

  String get content => _script.scriptTable[index].content ?? "";

  DateTime get date => _script.scriptTable[index].date;

  Future<void> _back() async {
    await _script.notifyBack(context);
    final currentTitle = _current.title ?? title;
    final currentContent = _current.content ?? content;
    if (currentTitle.isEmpty && currentContent.isEmpty) {
      await Future.delayed(Duration(milliseconds: 300));
      TrashMoveSnackBar.deleteEmpty(
        context: context,
        provider: _script,
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
        appBar: AppBar(toolbarHeight: 0),
        body: Hero(
          tag: id,
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              color: Colors.white,
              child: SafeArea(
                child: Column(
                  children: [
                    Container(child: _menuBar(context)),
                    Expanded(
                      child: SingleChildScrollView(
                        child: _script.current.state != ManuscriptState.trash
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
        ),
        floatingActionButton: SafeArea(
          child: FloatingActionButton(
            backgroundColor: ColorConfig.mainColor,
            shape: const CircleBorder(),
            onPressed: () async {
              if (_script.current.state != ManuscriptState.trash) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlaybackScreen(
                      title: _current.title ?? title,
                      content: _current.content ?? content,
                    ),
                  ),
                );
              }
            },
            child: Icon(Icons.play_arrow, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _menuBar(BuildContext context) {
    return Container(
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
          _script.current.state != ManuscriptState.trash
              ? _editStateMenu()
              : _trashStateMenu()
        ],
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
              hintText: S.current.placeholderTitle,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(0),
            ),
            style: const TextStyle(fontSize: 24),
            onChanged: (text) {
              _current.title = text;
              _script.saveScript(id: id, title: text);
            },
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
                hintText: S.current.placeholderContent,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(0),
              ),
              style: TextStyle(
                color: Colors.grey[800],
                height: 1.7,
                fontSize: 16,
              ),
              onChanged: (text) {
                _current.content = text;
                _script.saveScript(id: id, content: text);
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
            title.isNotEmpty ? title : S.current.noTitle,
            style: TextStyle(
              color: title.isNotEmpty ? null : Theme.of(context).hintColor,
              fontSize: 24,
            ),
          ),
          SizedBox(height: 16),
          Text(
            content.isNotEmpty ? content : S.current.noAdditionalText,
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
              if (_script.current.state != ManuscriptState.trash) {
                final tag = context.read<ManuscriptTagProvider>();
                final controller = TextEditingController();
                tag.loadTag(memoId: id);

                DialogManager.show(
                  context,
                  contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          hintText: S.current.addNewTag,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: ColorConfig.mainColor,
                            ),
                          ),
                        ),
                        controller: controller,
                        cursorColor: ColorConfig.mainColor,
                        onSubmitted: (text) {
                          if (text.trim().isNotEmpty) {
                            context
                                .read<ManuscriptTagProvider>()
                                .addTag(memoId: id, name: text);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(S.current.newTagAdded),
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
                              side: BorderSide(
                                color: Colors.grey[300]!,
                                width: 1,
                              ),
                              labelPadding: EdgeInsets.symmetric(vertical: 1),
                              padding: EdgeInsets.only(left: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              deleteIcon: Icon(
                                Icons.cancel,
                                color: ColorConfig.iconColor,
                                size: 18,
                              ),
                              label: Text(linkTagTable.tagName),
                              backgroundColor: Colors.transparent,
                              onDeleted: () {
                                final state = _script.current.state;
                                if (state != ManuscriptState.trash) {
                                  model.changeChecked(
                                    memoId: id,
                                    tagId: linkTagTable.id,
                                    newValue: false,
                                  );
                                }
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
          onPressed: () => Share.share(
            (_current.title ?? title) + "\n\n" + (_current.content ?? content),
          ),
        ),
        RippleIconButton(
          Icons.delete_outline,
          onPressed: () async {
            Navigator.pop(context);
            await Future.delayed(Duration(milliseconds: 300));
            TrashMoveSnackBar.move(
              context: context,
              provider: _script,
              index: index,
            );
          },
        ),
        RippleIconButton(
          Icons.info_outline,
          onPressed: () => {
            DialogManager.show(
              context,
              contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    S.current.characterCount(
                      Language.unit(_current.content ?? content),
                    ),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    CharCounter.count(_current.content ?? content).toString(),
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    S.current.presentationTime(
                      Language.perMinute(_current.content ?? content),
                    ),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    _calcReadTime(_current.content ?? content),
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    S.current.lastModified,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    DateFormat(
                      'yyyy/MM/dd(E) HH:mm',
                      Intl.getCurrentLocale(),
                    ).format(
                      _script.scriptTable[index].date,
                    ),
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              actions: [
                DialogTextButton(
                  S.current.close,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            )
          },
        ),
      ],
    );
  }

  String _calcReadTime(String text) {
    final char = Language.isEnglish(text)
        ? InitConfig.wordsPerMinute
        : InitConfig.charactersPerMinute;
    final count = CharCounter.count(text);

    final totalSecond = count / (char / 60);
    final minutes = totalSecond ~/ 60;
    final second = (totalSecond % 60).floor();

    return S.current.time(minutes, second);
  }

  Widget _trashStateMenu() {
    return Row(
      children: [
        RippleIconButton(
          Icons.restore_outlined,
          onPressed: () async {
            Navigator.pop(context);
            await Future.delayed(Duration(milliseconds: 300));
            TrashMoveSnackBar.restore(
              context: context,
              provider: _script,
              index: index,
            );
          },
        ),
        PopupMenu(
          [
            PopupMenuItem(
              child: Text(S.current.deletePermanently),
              value: "delete",
            )
          ],
          onSelected: (_) async {
            Navigator.pop(context);
            await Future.delayed(Duration(milliseconds: 300));
            TrashMoveSnackBar.delete(
              context: context,
              provider: _script,
              index: index,
            );
          },
        ),
      ],
    );
  }
}

class _CurrentScript {
  String? title;
  String? content;
}
