import 'package:flutter/material.dart';
import 'package:presc/view/screens/manuscript_search.dart';
import 'package:presc/view/utils/drawer_menu.dart';
import 'package:presc/view/utils/ripple_button.dart';
import 'package:presc/view/utils/script_card.dart';
import 'package:presc/viewModel/manuscript_provider.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';

class ManuscriptScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<ManuscriptProvider>(builder: (context, model, child) {
      return Scaffold(
        key: _scaffoldKey,
        appBar: !model.isVisibleSearchbar ? _appbar(model) : null,
        body: SafeArea(
          child: Scrollbar(
            child: CustomScrollView(
              slivers: [
                if (model.isVisibleSearchbar)
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
            onPressed: () {},
            child: Icon(Icons.add),
          ),
        ),
      );
    });
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

  Widget _appbar(ManuscriptProvider model) {
    return AppBar(
      elevation: 0,
      leading: RippleIconButton(
        Icons.navigate_before,
        size: 32,
        onPressed: () {
          model.itemList = '';
          model.isVisibleSearchbar = true;
        },
      ),
      title: Text(
        model.currentTag,
        style: TextStyle(fontSize: 20),
      ),
      actions: [
        AspectRatio(
          aspectRatio: 1,
          child: ClipOval(
            child: Material(
              type: MaterialType.transparency,
              child: PopupMenuButton<String>(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Text("タグ名を変更"),
                    value: "タグ名を変更",
                  ),
                  PopupMenuItem(
                    child: Text("タグを削除"),
                    value: "タグを削除",
                  ),
                ],
                onSelected: (value) {},
              ),
            ),
          ),
        ),
      ],
    );
  }
}
