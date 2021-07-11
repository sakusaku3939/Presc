import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:presc/view/utils/drawer_menu.dart';
import 'package:presc/view/utils/ripple_button.dart';
import 'package:presc/view/utils/script_card.dart';
import 'package:presc/viewModel/manuscript_provider.dart';
import 'package:provider/provider.dart';

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
              Consumer<ManuscriptProvider>(
                builder: (context, model, child) {
                  return SliverAppBar(
                    floating: true,
                    snap: true,
                    toolbarHeight: 80,
                    expandedHeight: 0,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: Container(),
                    flexibleSpace: model.isVisibleSearchbar
                        ? _searchbar()
                        : _appbar(model),
                  );
                },
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
        child: DrawerMenu(_scaffoldKey),
      ),
      floatingActionButton: SafeArea(
        child: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _searchbar() {
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

  Widget _appbar(ManuscriptProvider model) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: Colors.white,
      height: 56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              RippleIconButton(
                Icons.navigate_before,
                size: 32,
                onPressed: () {
                  model.itemList = '';
                  model.isVisibleSearchbar = true;
                },
              ),
              Padding(
                padding: EdgeInsets.only(left: 24),
                child: Text(
                  model.currentTag,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
          Row(
            children: [
              RippleIconButton(
                Icons.tune,
                onPressed: () => {},
              ),
            ],
          )
        ],
      ),
    );
    // return AppBar(
    //   elevation: 0,
    //   title: Text(
    //     model.currentTag,
    //     style: TextStyle(fontSize: 20),
    //   ),
    //   leading: IconButton(
    //     icon: Icon(Icons.navigate_before),
    //     iconSize: 32,
    //     onPressed: () {
    //       model.itemList = '';
    //       model.isVisibleSearchbar = true;
    //     },
    //   ),
    //   actions: <Widget>[
    //     IconButton(
    //       icon: Icon(Icons.tune),
    //       onPressed: () => {},
    //     ),
    //   ],
    // );
  }
}
