import 'package:flutter/material.dart';

Widget cardPageView(scaffoldKey) {
  const itemList = ['one', 'two', 'three', 'for'];
  return Container(
    child: Column(
      children: <Widget>[
        for (var item in itemList)
          Container(
            height: 296,
            margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: ScriptCard(item),
          )
      ],
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

class ScriptCard extends StatefulWidget {
  ScriptCard(this.heroTag);

  final String heroTag;

  @override
  State<StatefulWidget> createState() {
    return _ScriptCardState(heroTag);
  }
}

class _ScriptCardState extends State<ScriptCard> {
  _ScriptCardState(this.heroTag);

  String heroTag;
  var _hasPadding = false;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: Material(
        type: MaterialType.transparency,
        child: content(),
      ),
    );
  }

  Widget content() {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 80),
      padding: EdgeInsets.all(_hasPadding ? 8 : 0),
      child: GestureDetector(
        onTapDown: (TapDownDetails downDetails) {
          setState(() {
            _hasPadding = true;
          });
        },
        onTap: () {
          setState(() {
            _hasPadding = false;
          });
          Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 500),
                pageBuilder: (_, __, ___) => ScriptEditPage(heroTag),
              ));
        },
        onTapCancel: () {
          setState(() {
            _hasPadding = false;
          });
        },
        child: Container(
          constraints: BoxConstraints.expand(),
          padding: const EdgeInsets.only(left: 16, right: 16),
          decoration: cardShadow(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 12),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "原稿1",
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
              DefaultTextStyle(
                  style: new TextStyle(color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 6,
                  child: new Padding(
                    child: new Text(
                      "吾輩は猫である。名前はまだ無い。どこで生れたかとんと見当がつかぬ。何でも薄暗いじめじめした所でニャーニャー泣いていた事だけは記憶している。吾輩はここで始めて人間というものを見た。しかもあとで聞くとそれは書生という人間中で一番獰悪な種族であったそうだ。この書生というのは時々我々を捕えて煮て食うという話である。しかしその当時は何という考もなかったから別段恐しいとも思わなかった。ただ彼の掌に載せられてスーと持ち上げられた時何だかフワフワした感じがあったばかりである。",
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 16,
                      ),
                    ),
                    padding: new EdgeInsets.only(top: 12, left: 12),
                  )),
              Container(
                margin: const EdgeInsets.only(top: 16, right: 12),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    "2021/05/21 16:32",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
          // child: ClipRRect(
          //   // borderRadius: const BorderRadius.all(Radius.circular(8)),
          //   child: Align(
          //     alignment: Alignment.topCenter,
          //     child: Text("test"),
          //   ),
          // ),
        ),
      ),
    );
  }
}

class ScriptEditPage extends StatelessWidget {
  ScriptEditPage(this.heroTag);

  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Hero(
        tag: heroTag,
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  child: imageContents(context),
                ),
                Container(
                  child: Text('content'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget imageContents(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      height: 277,
      color: Colors.white,
      child: Container(
        child: Stack(
          children: <Widget>[
            Column(
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: statusBarHeight),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(),
                        Container(
                          child: RaisedButton(
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            color: Colors.blue,
                            shape: CircleBorder(),
                            onPressed: () {
                              Navigator.pop(
                                context,
                                // MaterialPageRoute(builder: (context) {
                                //   return Home();
                                // }),
                              );
                            },
                          ),
                        )
                      ]),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
