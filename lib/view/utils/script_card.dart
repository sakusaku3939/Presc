import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:presc/view/screens/manuscript_edit.dart';
import 'package:presc/view/utils/script_modal_bottom_sheet.dart';
import 'package:presc/viewModel/manuscript_provider.dart';
import 'package:provider/provider.dart';

Widget cardPageView() {
  return Container(
    margin: const EdgeInsets.only(top: 16),
    child: Selector<ManuscriptProvider, AnimatedList>(
      selector: (_, model) => model.scriptList,
      builder: (context, itemList, child) {
        return itemList;
      },
    ),
  );
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

class ScriptCard extends StatelessWidget {
  ScriptCard(this.heroTag);

  final String heroTag;

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
    return ScaleTap(
      scaleMinValue: 0.96,
      onPressed: () => Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 500),
          pageBuilder: (_, __, ___) => ManuscriptEditScreen(heroTag),
        ),
      ),
      onLongPress: () {
        ScriptModalBottomSheet().show(context);
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
                "原稿1",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 24),
              ),
            ),
            DefaultTextStyle(
              style: TextStyle(color: Colors.black),
              overflow: TextOverflow.ellipsis,
              maxLines: 6,
              child: Padding(
                child: Text(
                  "吾輩は猫である。名前はまだ無い。どこで生れたかとんと見当がつかぬ。何でも薄暗いじめじめした所でニャーニャー泣いていた事だけは記憶している。吾輩はここで始めて人間というものを見た。しかもあとで聞くとそれは書生という人間中で一番獰悪な種族であったそうだ。この書生というのは時々我々を捕えて煮て食うという話である。しかしその当時は何という考もなかったから別段恐しいとも思わなかった。ただ彼の掌に載せられてスーと持ち上げられた時何だかフワフワした感じがあったばかりである。",
                  style: TextStyle(
                    color: Colors.grey[800],
                    height: 1.8,
                    fontSize: 14,
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(12, 8, 4, 0),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 16, right: 12),
              child: Align(
                alignment: Alignment.topRight,
                child: Text(
                  "2021/05/21 16:32",
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
}
