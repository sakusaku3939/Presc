import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import "package:intl/intl.dart";
import 'package:presc/config/color_config.dart';
import 'package:presc/config/safe_area_size.dart';
import 'package:presc/model/utils/database_table.dart';
import 'package:presc/view/screens/manuscript_edit.dart';
import 'package:presc/view/utils/script_modal_bottom_sheet.dart';
import 'package:presc/viewModel/manuscript_provider.dart';
import 'package:presc/viewModel/manuscript_tag_provider.dart';
import 'package:provider/provider.dart';

class ScriptCard extends StatelessWidget {
  ScriptCard(this.context);

  final BuildContext context;
  final double _height = 280;

  @override
  Widget build(BuildContext context) {
    return Consumer<ManuscriptProvider>(
      builder: (context, model, child) {
        if (model.scriptTable == null)
          return _placeholder();
        else if (model.scriptTable.isEmpty)
          return _emptyView(model);
        else
          return MediaQuery.of(context).size.width < 500
              ? _mobileScriptView(model)
              : _tabletScriptView(model);
      },
    );
  }

  Widget _placeholder() => Container();

  Widget _emptyView(ManuscriptProvider model) {
    IconData icon;
    String text;
    switch (model.state) {
      case ManuscriptState.home:
      case ManuscriptState.tag:
        icon = Icons.description_outlined;
        text = "原稿がまだありません";
        break;
      case ManuscriptState.trash:
        icon = Icons.delete_outline;
        text = "ごみ箱は空です";
        break;
      case ManuscriptState.search:
        return _placeholder();
        break;
    }
    return Container(
      color: ColorConfig.backgroundColor,
      width: MediaQuery.of(context).size.width,
      height: SafeAreaSize.of(context).height -
          (model.state == ManuscriptState.tag ? 0 : 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.grey[600],
            size: 64,
          ),
          SizedBox(height: 8),
          Text(
            text,
            style: TextStyle(color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget _tabletScriptView(ManuscriptProvider model) {
    return OrientationBuilder(
      builder: (context, orientation) {
        final maxSize = orientation == Orientation.portrait
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.height;
        final isLarge = maxSize > 700;
        final columnCount = isLarge ? 3 : 2;
        return AnimationLimiter(
          child: GridView.count(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            childAspectRatio: maxSize / columnCount / (_height + 48),
            crossAxisCount: columnCount,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: List.generate(
              model.scriptTable.length,
              (int index) {
                return Container(
                  margin: const EdgeInsets.all(12),
                  child: AnimationConfiguration.staggeredGrid(
                    columnCount: columnCount,
                    position: index,
                    duration: const Duration(milliseconds: 300),
                    child: FadeInAnimation(
                      child: _Card(this.context, index),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _mobileScriptView(ManuscriptProvider model) {
    return AnimationLimiter(
      child: ListView.builder(
        itemCount: model.scriptTable.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: const EdgeInsets.all(12),
            height: _height,
            child: AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 300),
              child: FadeInAnimation(
                child: _Card(this.context, index),
              ),
            ),
          );
        },
      ),
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
  _Card(this.context, this.index);

  final BuildContext context;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Selector<ManuscriptProvider, List<MemoTable>>(
      selector: (_, model) => model.scriptTable,
      builder: (context, scriptTable, child) {
        return Hero(
          tag: scriptTable[index].id,
          child: Material(
            type: MaterialType.transparency,
            child: _card(scriptTable),
          ),
        );
      },
    );
  }

  Widget _card(List<MemoTable> scriptTable) {
    final title = scriptTable[index].title;
    final content = scriptTable[index].content;
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
                ManuscriptEditScreen(this.context, index),
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
                title.isNotEmpty ? title : "タイトルなし",
                textScaleFactor: 1,
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
                  padding: const EdgeInsets.fromLTRB(12, 8, 4, 0),
                  child: Text(
                    content.isNotEmpty
                        ? _optimizeContent(content)
                        : "追加のテキストはありません",
                    textScaleFactor: 1,
                    style: TextStyle(
                      color: Colors.grey[800],
                      height: 1.8,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 12, right: 12),
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
  }

  String _optimizeContent(String content) {
    final rangeText =
        content.length > 200 ? content.substring(0, 200) : content;
    String text = "";
    rangeText.split('\n').forEach((word) {
      text += word;
      if (word != '') text += '\n';
    });
    return text;
  }
}
