import 'package:flutter/material.dart';
import 'package:presc/view/utils/drawer_menu.dart';
import 'package:presc/view/utils/ripple_button.dart';
import 'package:presc/view/utils/script_card.dart';

class ManuscriptScreen extends StatelessWidget {
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
                toolbarHeight: 80,
                expandedHeight: 0,
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: Container(),
                flexibleSpace: _searchBar(),
              ),
              SliverList(
                delegate: SliverChildListDelegate([cardPageView()]),
              )
            ],
          ),
        ),
      ),
      drawer: GestureDetector(
        onTap: () {
          final FocusScopeNode currentScope = FocusScope.of(context);
          if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
            FocusManager.instance.primaryFocus.unfocus();
          }
        },
        child: DrawerMenu(),
      ),
      floatingActionButton: SafeArea(
        child: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _searchBar() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: cardShadow(8),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          child: Container(
            margin: const EdgeInsets.only(left: 4),
            child: Row(
              children: [
                RippleIconButton(
                  Icons.menu,
                  onPressed: () {
                    _scaffoldKey.currentState.openDrawer();
                  },
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
