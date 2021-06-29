import 'package:flutter/material.dart';

class LibraryScreen extends StatefulWidget {
  LibraryScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
              child: Container(
                child: const Text('テスト'),
              )),
        ));
  }
}

Widget appBar() {
  return SafeArea(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.fromLTRB(24, 20, 0, 20),
          child: Image.asset('assets/images/logo.png'),
        ),
        Container(
          margin: const EdgeInsets.only(right: 8),
          child: ClipOval(
            child: Material(
              type: MaterialType.transparency,
              child: IconButton(
                splashColor: Colors.grey[50],
                icon: Icon(Icons.search),
                onPressed: () {},
              ),
            ),
          ),
        ),
      ],
    ),
  );
}