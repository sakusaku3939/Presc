import 'package:flutter/material.dart';

class HScreen extends StatefulWidget {
  HScreen({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _HScreenState createState() => _HScreenState();
}

class _HScreenState extends State<HScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
              child: Container(
                child: const Text('index１のページです'),
              )),
        ));
  }
}