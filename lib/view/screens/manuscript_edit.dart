import 'package:flutter/material.dart';
import 'package:presc/view/utils/ripple_button.dart';

class ManuscriptEditScreen extends StatelessWidget {
  ManuscriptEditScreen(this.heroTag);

  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Hero(
        tag: heroTag,
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            color: Colors.white,
            child: Scrollbar(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                      floating: true,
                      snap: true,
                      toolbarHeight: 80,
                      expandedHeight: 80,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      leading: Container(),
                      flexibleSpace: _menuBar(context)),
                  SliverList(
                    delegate: SliverChildListDelegate([_content()]),
                  )
                ],
                // ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _menuBar(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        color: Colors.white,
        height: 56,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RippleIconButton(
              child: IconButton(
                icon: Icon(
                  Icons.navigate_before,
                  color: Colors.grey[700],
                  size: 32,
                ),
                onPressed: () => {Navigator.pop(context)},
              ),
            ),
            Row(
              children: [
                RippleIconButton(
                  child: IconButton(
                    icon: Icon(
                      Icons.share,
                      color: Colors.grey[700],
                    ),
                    onPressed: () => {},
                  ),
                ),
                RippleIconButton(
                  child: IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: Colors.grey[700],
                    ),
                    onPressed: () => {},
                  ),
                ),
                RippleIconButton(
                  child: IconButton(
                    icon: Icon(
                      Icons.info_outline,
                      color: Colors.grey[700],
                    ),
                    onPressed: () => {},
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _content() {
    return Container(
      child: Text("test"),
    );
  }
}