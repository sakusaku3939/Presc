import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:presc/core/constants/color_constants.dart';
import 'package:presc/core/constants/app_constants.dart';
import 'package:presc/generated/l10n.dart';
import 'package:presc/core/utils/char_counter_utils.dart';
import 'package:presc/core/utils/language_utils.dart';
import 'package:presc/features/playback/ui/pages/playback_page.dart';
import 'package:presc/shared/widgets/dialog/app_dialog.dart';
import 'package:presc/shared/widgets/menu/popup_menu.dart';
import 'package:presc/shared/widgets/ripple_button.dart';
import 'package:presc/features/tag/ui/widgets/tag_grid.dart';
import 'package:presc/features/manuscript/ui/providers/manuscript_tag_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../providers/manuscript_edit_provider.dart';

class ManuscriptEditPage extends StatelessWidget {
  ManuscriptEditPage(this.context, this.index, {this.autofocus = false});

  final BuildContext context;
  final int index;
  final bool autofocus;

  ManuscriptEditProvider get _edit => context.read<ManuscriptEditProvider>();

  @override
  Widget build(BuildContext context) {
    _edit.init(context, index);
    return WillPopScope(
      onWillPop: () async {
        await _edit.back(this.context);
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(toolbarHeight: 0),
        body: Hero(
          tag: _edit.id,
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
                        child: _edit.isEditable
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
            backgroundColor: ColorConstants.mainColor,
            shape: const CircleBorder(),
            onPressed: () async {
              if (_edit.isEditable) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlaybackPage(
                      title: _edit.title,
                      content: _edit.content,
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
            onPressed: () async => await _edit.back(this.context),
          ),
          _edit.isEditable ? _editStateMenu() : _trashStateMenu()
        ],
      ),
    );
  }

  Widget _editableContent(BuildContext context) {
    final controller = TextEditingController(text: _edit.content);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            cursorColor: Colors.black45,
            controller: TextEditingController.fromValue(
              TextEditingValue(
                text: _edit.title,
                selection: TextSelection.collapsed(offset: _edit.title.length),
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
            onChanged: (text) => _edit.title = text,
          ),
          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 32),
            child: Selector<ManuscriptEditProvider, int>(
              selector: (_, model) => model.currentHistory.offset,
              builder: (context, offset, child) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  controller.text = _edit.content;
                  controller.selection = TextSelection.collapsed(
                    offset: offset,
                  );
                });
                return TextField(
                  cursorColor: Colors.black45,
                  controller: controller,
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
                  onChanged: (text) => _edit.currentHistory = EditHistory(
                    text,
                    controller.selection.baseOffset,
                  ),
                );
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
            _edit.title.isNotEmpty ? _edit.title : S.current.noTitle,
            style: TextStyle(
              color:
                  _edit.title.isNotEmpty ? null : Theme.of(context).hintColor,
              fontSize: 24,
            ),
          ),
          SizedBox(height: 16),
          Text(
            _edit.content.isNotEmpty
                ? _edit.content
                : S.current.noAdditionalText,
            style: TextStyle(
              color: _edit.content.isNotEmpty
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
              if (_edit.isEditable) {
                final tag = context.read<ManuscriptTagProvider>();
                final controller = TextEditingController();
                tag.loadTag(memoId: _edit.id);

                AppDialog.show(
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
                              color: ColorConstants.mainColor,
                            ),
                          ),
                        ),
                        controller: controller,
                        cursorColor: ColorConstants.mainColor,
                        onSubmitted: (text) {
                          if (text.trim().isNotEmpty) {
                            context
                                .read<ManuscriptTagProvider>()
                                .addTag(memoId: _edit.id, name: text);
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
                      TagGrid(memoId: _edit.id),
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
                                color: ColorConstants.iconColor,
                                size: 18,
                              ),
                              label: Text(linkTagTable.tagName),
                              backgroundColor: Colors.transparent,
                              onDeleted: () {
                                if (_edit.isEditable) {
                                  model.changeChecked(
                                    memoId: _edit.id,
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
          onPressed: () => Share.share(_edit.title + "\n\n" + _edit.content),
        ),
        RippleIconButton(
          Icons.delete_outline,
          onPressed: () => _edit.moveToTrash(context),
        ),
        RippleIconButton(
          Icons.info_outline,
          onPressed: () => {
            AppDialog.show(
              context,
              contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    S.current.characterCount(
                      LanguageUtils.unit(_edit.content),
                    ),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    CharCounterUtils.count(_edit.content).toString(),
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    S.current.presentationTime(
                      LanguageUtils.perMinute(_edit.content),
                    ),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    _calcReadTime(_edit.content),
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
                    ).format(_edit.date),
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
        Consumer<ManuscriptEditProvider>(
          builder: (context, model, child) {
            return Row(
              children: [
                Container(
                  width: 44,
                  child: RippleIconButton(
                    Icons.undo,
                    onPressed: model.canUndo ? () => model.undo() : null,
                  ),
                ),
                Container(
                  width: 44,
                  child: RippleIconButton(
                    Icons.redo,
                    onPressed: model.canRedo ? () => model.redo() : null,
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  String _calcReadTime(String text) {
    final char = LanguageUtils.isEnglish(text)
        ? AppConstants.wordsPerMinute
        : AppConstants.charactersPerMinute;
    final count = CharCounterUtils.count(text);

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
          onPressed: () => _edit.restore(context),
        ),
        PopupMenu(
          [
            PopupMenuItem(
              child: Text(S.current.deletePermanently),
              value: "delete",
            )
          ],
          onSelected: (_) => _edit.delete(context),
        ),
      ],
    );
  }
}
