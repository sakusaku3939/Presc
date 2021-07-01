import 'package:flutter/material.dart';
import 'package:presc/view/commons/script_card.dart';

class ManuscriptScreen extends StatefulWidget {
  ManuscriptScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ManuscriptScreenState createState() => _ManuscriptScreenState();
}

class _ManuscriptScreenState extends State<ManuscriptScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  toolbarHeight: 80,
                  expandedHeight: 0,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: Container(),
                  flexibleSpace: searchBar(_scaffoldKey),
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
        child: Icon(Icons.add),
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
                        color: Colors.grey,
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
