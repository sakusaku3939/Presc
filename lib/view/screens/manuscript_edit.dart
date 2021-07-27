import 'package:flutter/material.dart';
import 'package:presc/view/screens/playback.dart';
import 'package:presc/view/utils/ripple_button.dart';

class ManuscriptEditScreen extends StatelessWidget {
  ManuscriptEditScreen(this.heroTag, {
    @required this.title,
    @required this.content,
    @required this.date,
  });

  final String heroTag;
  final String title;
  final String content;
  final DateTime date;

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
            child: Column(
              children: [
                Container(child: _menuBar(context)),
                Expanded(
                    child: SingleChildScrollView(child: _content(context))),
                Container(child: _footer()),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: SafeArea(
        child: FloatingActionButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PlaybackScreen()),
          ),
          child: Icon(Icons.play_arrow),
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
              Icons.navigate_before,
              size: 32,
              onPressed: () => Navigator.pop(context),
            ),
            Row(
              children: [
                RippleIconButton(
                  Icons.share,
                  onPressed: () => {},
                ),
                RippleIconButton(
                  Icons.delete_outline,
                  onPressed: () => {},
                ),
                RippleIconButton(
                  Icons.info_outline,
                  onPressed: () => {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _content(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            cursorColor: Colors.black45,
            controller: TextEditingController.fromValue(
              TextEditingValue(
                text: title,
                selection: TextSelection.collapsed(offset: title.length),
              ),
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.go,
            maxLines: null,
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(0),
            ),
            style: TextStyle(fontSize: 24),
          ),
          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 32),
            child: TextField(
              cursorColor: Colors.black45,
              controller: TextEditingController.fromValue(
                TextEditingValue(
                  text: content,
                  selection: TextSelection.collapsed(offset: content.length),
                ),
              ),
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              maxLines: null,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(0),
              ),
              style: TextStyle(
                color: Colors.grey[800],
                height: 1.7,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _footer() {
    final _chipList = ["夏目漱石", "練習用"];
    return Container(
      height: 48,
      padding: const EdgeInsets.only(left: 16, right: 88),
      child: Row(
        children: [
          RippleIconButton(
            Icons.playlist_add,
            onPressed: () {},
          ),
          Expanded(
            child: ScrollConfiguration(
              behavior: ScrollBehavior(),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (var i = 0; i < _chipList.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Chip(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.grey[300], width: 1),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          deleteIcon: Icon(
                            Icons.cancel,
                            color: Colors.grey[700],
                            size: 18,
                          ),
                          backgroundColor: Colors.transparent,
                          key: Key(i.toString()),
                          label: Text(_chipList[i]),
                          onDeleted: () => {},
                        ),
                      )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
