import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.deepOrange[400],
          accentColor: Colors.deepOrange[400],
          scaffoldBackgroundColor: Color(0xFFF7F7F7)),
      home: Scaffold(
        appBar: SearchBar(),
        body: Center(
          child: Text('Body'),
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
          tooltip: '原稿を追加',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 40,
          right: 24,
          left: 24,
          child: Container(
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Material(
                  type: MaterialType.transparency,
                  child: IconButton(
                    splashColor: Colors.grey,
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
                Expanded(
                  child: TextField(
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.go,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        hintText: "原稿を検索"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(64);
}
