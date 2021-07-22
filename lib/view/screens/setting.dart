import 'package:flutter/material.dart';
import 'package:presc/view/utils/playback_text_view.dart';
import 'package:presc/view/utils/ripple_button.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(context),
      body: SafeArea(
        child: Column(
          children: [
            _preview(),
          ],
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32),
      color: Colors.grey[900],
      child: PlaybackTextView(
        "吾輩は猫である。名前はまだ無い。\n"
        "どこで生れたかとんと見当がつかぬ。何でも薄暗いじめじめした所でニャーニャー泣いていた事だけは記憶している。"
        "吾輩はここで始めて人間というものを見た。しかもあとで聞くとそれは書生という人間中で一番獰悪な種族であったそうだ。",
        height: 200,
        scroll: false,
        gradientFraction: 0.5,
      ),
    );
  }
}
