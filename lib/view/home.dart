import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    ScrollController _scrollController = ScrollController();

    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.deepOrange[400],
          accentColor: Colors.deepOrange[400],
          scaffoldBackgroundColor: Color(0xFFF7F7F7)),
      home: Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
          child: PrimaryScrollController(
            controller: _scrollController,
            child: Scrollbar(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    floating: true,
                    snap: true,
                    toolbarHeight: 64,
                    expandedHeight: 0,
                    backgroundColor: Color(0xFFF7F7F7),
                    elevation: 1,
                    leading: Container(),
                    flexibleSpace: appBar(),
                  ),
                  SliverList(
                    delegate:
                        SliverChildListDelegate([cardPageView(_scaffoldKey)]),
                  )
                ],
              ),
            ),
          ),
        ),
        // body: Center(
        //   child: cardPageView(_scaffoldKey),
        // ),
        drawer: Drawer(
          child: SafeArea(
            right: false,
            child: Center(
              child: Text('Drawer content'),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          tooltip: '原稿を追加',
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget cardPageView(scaffoldKey) {
    const itemList = ['one', 'two', 'three', 'for'];
    return Container(
      child: Column(
        children: <Widget>[
          for (var item in itemList)
            Container(
              height: 320,
              margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: CustomCard(item),
            )
        ],
      ),
    );
  }

  Widget appBar() {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.fromLTRB(24, 20, 0, 20),
            child: Image.asset('assets/images/logo.png'),
          ),
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: ClipOval(
              child: Material(
                type: MaterialType.transparency,
                child: IconButton(
                  splashColor: Colors.grey[50],
                  icon: Icon(Icons.search),
                  onPressed: () {},
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget searchBar(scaffoldKey) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: cardShadow(8),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          child: Container(
            margin: const EdgeInsets.only(left: 4),
            child: Row(
              children: <Widget>[
                ClipOval(
                  child: Material(
                    type: MaterialType.transparency,
                    child: IconButton(
                      splashColor: Colors.grey[50],
                      icon: Icon(Icons.menu),
                      onPressed: () {
                        scaffoldKey.currentState.openDrawer();
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 24),
                    child: Text(
                      "原稿を検索",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class ScriptCard extends StatefulWidget {
//   ScriptCard(this.heroTag);
//
//   String heroTag;
//
//   @override
//   State<StatefulWidget> createState() {
//     return ScriptCardState(heroTag);
//   }
// }
//
// class ScriptCardState extends State<ScriptCard> {
//   ScriptCardState(this.heroTag);
//
//   String heroTag;
//
//   var _hasPadding = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Hero(
//       tag: heroTag,
//       child: content(),
//     );
//   }
//
//   Widget content() {
//     return AnimatedPadding(
//       duration: const Duration(milliseconds: 80),
//       padding: EdgeInsets.all(_hasPadding ? 8 : 0),
//       child: GestureDetector(
//         onTapDown: (TapDownDetails downDetails) {
//           setState(() {
//             _hasPadding = true;
//             print(_hasPadding);
//           });
//         },
//         onTap: () {
//           setState(() {
//             _hasPadding = false;
//           });
//           Navigator.push(
//               context,
//               PageRouteBuilder(
//                 transitionDuration: Duration(milliseconds: 500),
//                 pageBuilder: (_, __, ___) => ScriptEditPage(heroTag),
//               ));
//         },
//         onTapCancel: () {
//           setState(() {
//             _hasPadding = false;
//           });
//         },
//         child: Container(
//           constraints: BoxConstraints.expand(),
//           // margin: const EdgeInsets.all(16.0),
//           decoration: cardShadow(),
//           child: ClipRRect(
//             borderRadius: const BorderRadius.all(Radius.circular(8)),
//             child: Align(
//               alignment: Alignment.topCenter,
//               child: Text("test"),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class ScriptEditPage extends StatelessWidget {
//   ScriptEditPage(this.heroTag);
//
//   String heroTag;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Hero(
//           tag: heroTag,
//           child: content(),
//         ),
//       ),
//     );
//   }
//
//   Widget content() {
//     return Column(
//       children: <Widget>[
//         Container(
//           child: Text('title'),
//         ),
//         Container(
//           child: Text('content'),
//         )
//       ],
//     );
//   }
// }

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

class CustomCard extends StatefulWidget {
  CustomCard(this.heroTag);

  String heroTag;

  @override
  State<StatefulWidget> createState() {
    return CustomCardState(heroTag);
  }
}

class CustomCardState extends State<CustomCard> {
  CustomCardState(this.heroTag);

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
                pageBuilder: (_, __, ___) => DetailPage(heroTag),
              ));
        },
        onTapCancel: () {
          setState(() {
            _hasPadding = false;
          });
        },
        child: Container(
          constraints: BoxConstraints.expand(),
          // margin: const EdgeInsets.all(16.0),
          decoration: cardShadow(16),
          child: ClipRRect(
            // borderRadius: const BorderRadius.all(Radius.circular(8)),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text("test"),
            ),
          ),
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  DetailPage(this.heroTag);

  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, //Widgetの全体の背景を透明にする
      body: Hero(
        tag: heroTag,
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            color: Colors.white, //HeroWidget以下のツリーの背景を白色にする,
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

  // 画像Widget
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
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween, // これで両端に寄せる
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
                                MaterialPageRoute(builder: (context) {
                                  return Home();
                                }),
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
