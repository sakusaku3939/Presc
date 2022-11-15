import 'package:flutter/material.dart';
import 'package:presc/config/color_config.dart';
import 'package:presc/view/utils/drawer_menu.dart';
import 'package:presc/view/utils/ripple_button.dart';
import 'package:presc/view/utils/script_card.dart';
import 'package:presc/viewModel/editable_tag_item_provider.dart';
import 'package:presc/viewModel/manuscript_provider.dart';
import 'package:presc/viewModel/manuscript_tag_provider.dart';
import 'package:provider/provider.dart';

import 'manuscript_edit.dart';

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
                backgroundColor: ColorConfig.backgroundColor,
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
            final script = context.read<ManuscriptProvider>();
            final tag = context.read<ManuscriptTagProvider>();
            final id = await script.addScript(title: "", content: "");

            await script.updateScriptTable();
            await tag.loadTag(memoId: id);

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
              final tagItem = context.read<EditableTagItemProvider>();
              tagItem.loadTag();
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 20, 8, 20),
            child: Image.asset('assets/images/logo.png'),
          ),
          RippleIconButton(
            Icons.search,
            onPressed: () {
              context
                  .read<ManuscriptProvider>()
                  .replaceState(ManuscriptState.search);
            },
          ),
        ],
      ),
    );
  }
}
