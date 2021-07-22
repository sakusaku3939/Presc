import 'package:flutter/material.dart';
import 'package:presc/view/screens/setting.dart';
import 'package:presc/view/utils/playback_text_view.dart';
import 'package:presc/view/utils/ripple_button.dart';

class PlayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: _appbar(context),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(32, 0, 32, 8),
                child: PlaybackTextView(
                  "吾輩は猫である。名前はまだ無い。\n"
                  "どこで生れたかとんと見当がつかぬ。何でも薄暗いじめじめした所でニャーニャー泣いていた事だけは記憶している。吾輩はここで始めて人間というものを見た。しかもあとで聞くとそれは書生という人間中で一番獰悪な種族であったそうだ。この書生というのは時々我々を捕えて煮て食うという話である。しかしその当時は何という考もなかったから別段恐しいとも思わなかった。ただ彼の掌に載せられてスーと持ち上げられた時何だかフワフワした感じがあったばかりである。\n"
                  "\n"
                  "ようやくの思いで笹原を這い出すと向うに大きな池がある。吾輩は池の前に坐ってどうしたらよかろうと考えて見た。別にこれという分別も出ない。しばらくして泣いたら書生がまた迎に来てくれるかと考え付いた。ニャー、ニャーと試みにやって見たが誰も来ない。そのうち池の上をさらさらと風が渡って日が暮れかかる。腹が非常に減って来た。泣きたくても声が出ない。仕方がない、何でもよいから食物のある所まであるこうと決心をしてそろりそろりと池を左りに廻り始めた。どうも非常に苦しい。そこを我慢して無理やりに這って行くとようやくの事で何となく人間臭い所へ出た。",
                ),
              ),
            ),
            Text(
              "0:17",
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 12, 32, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 48,
                    child: RippleIconButton(
                      Icons.mic,
                      size: 28,
                      color: Colors.white,
                      onPressed: () => {},
                    ),
                  ),
                  Container(
                    width: 48,
                    child: RippleIconButton(
                      Icons.skip_previous_outlined,
                      size: 32,
                      color: Colors.white,
                      onPressed: () => {},
                    ),
                  ),
                  Container(
                    width: 64,
                    child: FittedBox(
                      child: FloatingActionButton(
                        onPressed: () {},
                        child: Icon(Icons.play_arrow),
                      ),
                    ),
                  ),
                  Container(
                    width: 48,
                    child: RippleIconButton(
                      Icons.skip_next_outlined,
                      size: 32,
                      color: Colors.white,
                      onPressed: () => {},
                    ),
                  ),
                  Container(
                    width: 48,
                    child: RippleIconButton(
                      Icons.text_rotate_vertical,
                      size: 28,
                      color: Colors.white,
                      onPressed: () => {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _appbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.grey[900],
      centerTitle: true,
      elevation: 0,
      leading: RippleIconButton(
        Icons.navigate_before,
        color: Colors.white,
        size: 32,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        "原稿1",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 4),
          child: RippleIconButton(
            Icons.settings,
            color: Colors.white,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingScreen()),
            ),
          ),
        ),
      ],
    );
  }
}
