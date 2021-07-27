import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:presc/model/manuscript_manager.dart';
import 'package:presc/view/utils/drawer_menu.dart';
import 'package:presc/view/utils/ripple_button.dart';
import 'package:presc/view/utils/script_card.dart';

import 'manuscript_search.dart';

class ManuscriptHomeScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Scrollbar(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                snap: true,
                toolbarHeight: 64,
                expandedHeight: 0,
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: Container(),
                flexibleSpace: _searchbar(),
              ),
              SliverList(
                delegate: SliverChildListDelegate([cardPageView()]),
              )
            ],
          ),
        ),
      ),
      drawer: DrawerMenu(_scaffoldKey),
      floatingActionButton: SafeArea(
        child: FloatingActionButton(
          onPressed: () => ManuscriptManager().insert(title: "test", content: "content"),
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _searchbar() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        decoration: cardShadow(8),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          child: OpenContainer(
            openBuilder: (_, closeContainer) => ManuscriptSearchScreen(),
            onClosed: (res) => {},
            tappable: true,
            closedElevation: 0,
            closedBuilder: (_, openContainer) => GestureDetector(
              onTap: openContainer,
              child: Container(
                margin: const EdgeInsets.only(left: 4),
                child: Row(
                  children: [
                    RippleIconButton(
                      Icons.menu,
                      onPressed: () => _scaffoldKey.currentState.openDrawer(),
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
        ),
      ),
    );
  }
}
