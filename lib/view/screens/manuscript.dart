import 'package:flutter/material.dart';
import 'package:presc/view/commons/ripple_button.dart';
import 'package:presc/view/commons/script_card.dart';

class ManuscriptScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

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
                      SliverChildListDelegate([cardPageView()]),
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
      floatingActionButton: SafeArea(child: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
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
                RippleIconButton(
                  child: IconButton(
                    splashColor: Colors.grey[50],
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      scaffoldKey.currentState.openDrawer();
                    },
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
