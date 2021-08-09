import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import "package:intl/intl.dart";
import 'package:presc/model/utils/database_table.dart';
import 'package:presc/view/screens/manuscript_edit.dart';
import 'package:presc/view/utils/script_modal_bottom_sheet.dart';
import 'package:presc/viewModel/manuscript_provider.dart';
import 'package:presc/viewModel/manuscript_tag_provider.dart';
import 'package:provider/provider.dart';

class ScriptCard extends StatelessWidget {
  ScriptCard(this.context);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Consumer<ManuscriptProvider>(
        builder: (context, model, child) {
          if (model.scriptTable == null)
            return _placeholder();
          else if (model.scriptTable.isEmpty)
            return _emptyView(model);
          else
            return _scriptListView(model);
        },
      ),
    );
  }

  Widget _placeholder() => Container();

  Widget _emptyView(ManuscriptProvider model) {
    return Container(
      height: MediaQuery.of(context).size.height -
          (model.state != ManuscriptState.trash ? 120 : 140),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            model.state != ManuscriptState.trash
                ? Icons.description_outlined
                : Icons.delete_outline,
            color: Colors.grey[600],
            size: 64,
          ),
          SizedBox(height: 8),
          Text(
            model.state != ManuscriptState.trash ? "原稿がまだありません" : "ごみ箱は空です",
            style: TextStyle(color: Colors.grey[700]),
          ),
          AnimatedList(
            key: model.listKey,
            shrinkWrap: true,
            itemBuilder:
                (BuildContext context, int index, Animation animation) {
              return Container();
            },
          ),
        ],
      ),
    );
  }

  Widget _scriptListView(ManuscriptProvider model) {
    return AnimatedList(
      key: model.listKey,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      initialItemCount: 0,
      itemBuilder: (BuildContext context, int index, Animation animation) {
        return FadeTransition(
          opacity: animation,
          child: Container(
            height: 280,
            margin: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: _Card(context, "${model.state}$index", index),
          ),
        );
      },
    );
  }
}

BoxDecoration cardShadow(double radius) {
  return BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(radius)),
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.grey[300],
        offset: const Offset(0, 2),
        blurRadius: 20,
      ),
    ],
  );
}

class _Card extends StatelessWidget {
  _Card(this.context, this.heroTag, this.index);

  final BuildContext context;
  final String heroTag;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: Material(
        type: MaterialType.transparency,
        child: _card(context),
      ),
    );
  }

  Widget _card(BuildContext context) {
    return Selector<ManuscriptProvider, List<MemoTable>>(
      selector: (_, model) => model.scriptTable,
      builder: (context, scriptTable, child) {
        return ScaleTap(
          scaleMinValue: 0.96,
          onPressed: () {
            context
                .read<ManuscriptTagProvider>()
                .loadTag(memoId: scriptTable[index].id);
            Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 500),
                pageBuilder: (_, __, ___) =>
                    ManuscriptEditScreen(this.context, heroTag, index),
              ),
            );
          },
          onLongPress: () {
            ScriptModalBottomSheet.show(this.context, index);
          },
          child: Container(
            constraints: const BoxConstraints.expand(),
            padding: const EdgeInsets.only(left: 16, right: 16),
            decoration: cardShadow(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 12),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    scriptTable[index].title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: DefaultTextStyle(
                    style: TextStyle(color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 6,
                    child: Padding(
                      child: Text(
                        scriptTable[index].content,
                        style: TextStyle(
                          color: Colors.grey[800],
                          height: 1.8,
                          fontSize: 14,
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(12, 8, 4, 0),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 16, right: 12),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      DateFormat('yyyy/MM/dd(E) HH:mm', "ja_JP").format(
                        scriptTable[index].date,
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
