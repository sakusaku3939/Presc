import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:presc/config/custom_color.dart';
import 'package:presc/view/utils/drawer_menu.dart';
import 'package:presc/view/utils/ripple_button.dart';
import 'package:presc/view/utils/script_card.dart';
import 'package:presc/viewModel/editable_tag_item_provider.dart';
import 'package:presc/viewModel/manuscript_provider.dart';
import 'package:presc/viewModel/manuscript_tag_provider.dart';
import 'package:provider/provider.dart';

import 'manuscript_edit.dart';
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
                backgroundColor: CustomColor.backgroundColor,
                elevation: 0,
                leading: Container(),
                flexibleSpace: _appbar(context),
              ),
              SliverList(
                delegate: SliverChildListDelegate([ScriptCard(context)]),
              )
            ],
          ),
        ),
      ),
      drawer: DrawerMenu(_scaffoldKey),
      floatingActionButton: SafeArea(
        child: FloatingActionButton(
          onPressed: () async {
            final provider = context.read<ManuscriptProvider>();
            final id = await provider.addScript(title: "", content: "");
            await provider.updateScriptTable(sort: true);
            await context.read<ManuscriptTagProvider>().loadTag(memoId: id);
            provider.insertScriptItem(0);
            Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 500),
                pageBuilder: (_, __, ___) =>
                    ManuscriptEditScreen(context, 0, autofocus: true),
              ),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _appbar(BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RippleIconButton(
            Icons.menu,
            onPressed: () {
              context.read<EditableTagItemProvider>().loadTag();
              _scaffoldKey.currentState.openDrawer();
            },
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 20, 8, 20),
            child: Image.asset('assets/images/logo.png'),
          ),
          RippleIconButton(
            Icons.search,
            onPressed: () {
              context.read<EditableTagItemProvider>().loadTag();
              _scaffoldKey.currentState.openDrawer();
            },
          ),
        ],
      ),
    );
    return SafeArea(
      child: Row(
          children: [
            RippleIconButton(
              Icons.menu,
              onPressed: () {
                context.read<EditableTagItemProvider>().loadTag();
                _scaffoldKey.currentState.openDrawer();
              },
            ),
            Image.asset(
              'assets/images/logo.png',
              alignment: Alignment.centerLeft,
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
    );
  }

  Widget _searchbar(BuildContext context) {
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
                      onPressed: () {
                        context.read<EditableTagItemProvider>().loadTag();
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
        ),
      ),
    );
  }
}
