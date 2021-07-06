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
                    pinned: true,
                    toolbarHeight: 56,
                    expandedHeight: 56,
                    backgroundColor: Colors.white,
                    elevation: 1,
                    leading: Container(),
                    flexibleSpace: _menuBar(context),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([_content()]),
                  ),
                ],
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
      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "原稿1",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 24),
          ),
          Container(
            margin: EdgeInsets.only(top: 16, bottom: 40),
            child: Text(
              "吾輩は猫である。名前はまだ無い。\n"
              "どこで生れたかとんと見当がつかぬ。何でも薄暗いじめじめした所でニャーニャー泣いていた事だけは記憶している。吾輩はここで始めて人間というものを見た。しかもあとで聞くとそれは書生という人間中で一番獰悪な種族であったそうだ。この書生というのは時々我々を捕えて煮て食うという話である。しかしその当時は何という考もなかったから別段恐しいとも思わなかった。ただ彼の掌に載せられてスーと持ち上げられた時何だかフワフワした感じがあったばかりである。\n"
              "\n"
              "ようやくの思いで笹原を這い出すと向うに大きな池がある。吾輩は池の前に坐ってどうしたらよかろうと考えて見た。別にこれという分別も出ない。しばらくして泣いたら書生がまた迎に来てくれるかと考え付いた。ニャー、ニャーと試みにやって見たが誰も来ない。そのうち池の上をさらさらと風が渡って日が暮れかかる。腹が非常に減って来た。泣きたくても声が出ない。仕方がない、何でもよいから食物のある所まであるこうと決心をしてそろりそろりと池を左りに廻り始めた。どうも非常に苦しい。そこを我慢して無理やりに這って行くとようやくの事で何となく人間臭い所へ出た。",
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
}
