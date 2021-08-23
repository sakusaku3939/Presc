import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:presc/config/sample_text.dart';
import 'package:presc/view/utils/ripple_button.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _appbar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _preview(),
              _fontMenu(),
              SizedBox(height: 8),
              Ink(
                color: Colors.white,
                child: ListTile(
                  title: Text("音声認識"),
                  subtitle: Text("オン"),
                  contentPadding: EdgeInsets.only(left: 32),
                  onTap: () => {},
                ),
              ),
              Ink(
                color: Colors.white,
                child: ListTile(
                  title: Text("再生モード"),
                  subtitle: Text("自動スクロール"),
                  contentPadding: EdgeInsets.only(left: 32),
                  onTap: () => {},
                ),
              ),
              Ink(
                color: Colors.white,
                child: ListTile(
                  title: Text("再生速度"),
                  subtitle: Text("x 1.0"),
                  contentPadding: EdgeInsets.only(left: 32),
                  onTap: () => {},
                ),
              ),
              SizedBox(height: 16),
              Ink(
                color: Colors.white,
                child: ListTile(
                  title: Text("このアプリについて"),
                  contentPadding: EdgeInsets.only(left: 32),
                  onTap: () => {},
                ),
              ),
              Ink(
                color: Colors.white,
                child: ListTile(
                  title: Text("オープンソースライセンス"),
                  contentPadding: EdgeInsets.only(left: 32),
                  onTap: () => {},
                ),
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appbar(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: RippleIconButton(
        Icons.navigate_before,
        size: 32,
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        "再生設定",
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  Widget _preview() {
    final ScrollController scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(24);
    });
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32),
      color: Colors.grey[900],
      child: Container(
        height: 200,
        child: FadingEdgeScrollView.fromSingleChildScrollView(
          gradientFractionOnStart: 0.5,
          gradientFractionOnEnd: 0.5,
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Text(
                SampleText.setting,
                style: TextStyle(
                  color: Colors.white,
                  height: 2.2,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _fontMenu() {
    return Container(
      height: 40,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton.icon(
            onPressed: () => {},
            icon: Icon(Icons.format_size),
            label: Text('20'),
            style: TextButton.styleFrom(
              primary: Colors.grey[700],
            ),
          ),
          TextButton.icon(
            onPressed: () => {},
            icon: Icon(Icons.format_line_spacing),
            label: Text('2.2'),
            style: TextButton.styleFrom(
              primary: Colors.grey[700],
            ),
          ),
          TextButton.icon(
            onPressed: () => {},
            icon: Icon(Icons.format_color_text),
            label: Text('□'),
            style: TextButton.styleFrom(
              primary: Colors.grey[700],
            ),
          ),
          TextButton.icon(
            onPressed: () => {},
            icon: Icon(Icons.format_color_fill),
            label: Text('■'),
            style: TextButton.styleFrom(
              primary: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
