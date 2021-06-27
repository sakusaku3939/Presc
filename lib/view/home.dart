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
    final borderRadius = BorderRadius.all(Radius.circular(8));
    return Stack(
      children: <Widget>[
        Positioned(
          top: 24,
          right: 8,
          left: 8,
          child: Container(
            margin: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[200],
                  offset: Offset(0.0, 3.0),
                  blurRadius: 16.0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: borderRadius,
              child: Container(
                margin: EdgeInsets.only(left: 4),
                child: Row(
                  children: <Widget>[
                    ClipOval(
                      child: Material(
                        type: MaterialType.transparency,
                        child: IconButton(
                          splashColor: Colors.grey[50],
                          icon: Icon(Icons.menu),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 24),
                        child: Text(
                          "原稿を検索",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      // TextField(
                      //   cursorColor: Colors.black,
                      //   keyboardType: TextInputType.text,
                      //   textInputAction: TextInputAction.go,
                      //   decoration: InputDecoration(
                      //       border: InputBorder.none,
                      //       contentPadding:
                      //           EdgeInsets.symmetric(horizontal: 16),
                      //       hintText: "原稿を検索"),
                      // ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(88);
}
