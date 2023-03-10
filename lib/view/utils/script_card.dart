import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import "package:intl/intl.dart";
import 'package:presc/config/display_size.dart';
import 'package:presc/generated/l10n.dart';
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
    return Selector<ManuscriptProvider, List<MemoTable>>(
      selector: (_, model) => model.scriptTable,
      builder: (context, scriptTable, child) {
        if (scriptTable.length <= 0)
          return _placeholder();
        else
          return _scriptView(scriptTable.length);
      },
    );
  }

  Widget _placeholder() => Container();

  Widget _emptyView() {
    return Selector<ManuscriptProvider, Current>(
      selector: (_, model) => model.current,
      builder: (context, current, child) {
        IconData icon;
        String text;
        switch (current.state) {
          case ManuscriptState.home:
          case ManuscriptState.tag:
            icon = Icons.description_outlined;
            text = S.current.noScriptYet;
            break;

          case ManuscriptState.trash:
            icon = Icons.delete_outline;
            text = S.current.noAdditionalText;
            break;

          case ManuscriptState.search:
            return _placeholder();
        }
        return Container(
          width: MediaQuery.of(context).size.width,
          height: DisplaySize.safeArea(context).height -
              (current.state == ManuscriptState.tag ? 0 : 30),
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
      },
    );
  }

  Widget _scriptView(int length) {
    return OrientationBuilder(
      builder: (context, orientation) {
        final width = MediaQuery.of(context).size.width;
        if (width < 500)
          return _mobileScriptView(length);
        else if (width < 700)
          return _tabletScriptView(length, 2);
        else
          return _tabletScriptView(length, 3);
      },
    );
  }

  Widget _mobileScriptView(int length) {
    return AnimationLimiter(
      child: ListView.builder(
        itemCount: length,
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

  Widget _tabletScriptView(int length, int columnCount) {
    return AnimationLimiter(
      child: GridView.count(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        childAspectRatio:
            MediaQuery.of(context).size.width / columnCount / (_height + 48),
        crossAxisCount: columnCount,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: List.generate(
          length,
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
  }
}

BoxDecoration cardShadow(double radius) {
  return BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(radius)),
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.grey[200]!,
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
        if (index < scriptTable.length)
          return Hero(
            tag: scriptTable[index].id,
            child: Material(
              type: MaterialType.transparency,
              child: _card(scriptTable),
            ),
          );
        else
          return Container();
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
                (title != null && title.isNotEmpty) ? title : S.current.noTitle,
                textScaleFactor: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 24),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: DefaultTextStyle(
                style: const TextStyle(color: Colors.black),
                overflow: TextOverflow.ellipsis,
                maxLines: 6,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 4, 0),
                  child: Text(
                    (content != null && content.isNotEmpty)
                        ? _optimizeContent(content)
                        : S.current.noAdditionalText,
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
                  DateFormat(
                    'yyyy/MM/dd(E) HH:mm',
                    Intl.getCurrentLocale(),
                  ).format(
                    scriptTable[index].date,
                  ),
                  style: const TextStyle(
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
        content.length > 400 ? content.substring(0, 400) : content;
    String text = "";
    rangeText.split('\n').forEach((word) {
      text += word;
      if (word != '') text += '\n';
    });
    return text;
  }
}
