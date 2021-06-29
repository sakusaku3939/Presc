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
}
