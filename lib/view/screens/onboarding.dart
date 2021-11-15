import 'dart:ui';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:presc/viewModel/onboarding_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'manuscript.dart';

class OnBoardingScreen extends StatelessWidget {
  final _controller = PageController();

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _page1(context),
      _page2(),
      _page3(),
      _page4(),
    ];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.addListener(() {
        context.read<OnBoardingProvider>().position = _controller.page;
      });
    });
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Opacity(
                opacity: 0.2,
                child: Image.asset("assets/images/icon2.png"),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.black.withOpacity(0)),
            ),
            Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: pages.length,
                    itemBuilder: (context, index) {
                      return pages[index];
                    },
                  ),
                ),
                Consumer<OnBoardingProvider>(
                  builder: (context, model, child) {
                    final isLastPage = model.position > pages.length - 1.5;
                    return Row(
                      children: [
                        Container(
                          width: 80,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: !isLastPage
                              ? TextButton(
                                  style: TextButton.styleFrom(
                                    primary: Colors.grey[800],
                                  ),
                                  child: Text("スキップ"),
                                  onPressed: () => _nextPage(pages.length - 1),
                                )
                              : Container(),
                        ),
                        Expanded(
                          child: Container(
                            height: 32,
                            child: DotsIndicator(
                              dotsCount: pages.length,
                              position: model.position,
                              decorator: DotsDecorator(
                                size: const Size.square(9.0),
                                activeColor: Theme.of(context).accentColor,
                                activeSize: const Size(18.0, 9.0),
                                activeShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 80,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              primary: Colors.grey[800],
                            ),
                            child: Text(!isLastPage ? "次へ" : "始める"),
                            onPressed: () async {
                              if (isLastPage) {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setBool("isFirstLaunch", false);
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ManuscriptScreen()),
                                  (_) => false,
                                );
                              } else {
                                _nextPage(model.position.round() + 1);
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _nextPage(int page) => _controller.animateToPage(
        page,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );

  Widget _page1(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 400,
            ),
            child: Container(
              padding: const EdgeInsets.only(top: 80),
              width: MediaQuery.of(context).size.width * 0.5,
              child: Image.asset("assets/images/logo.png"),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            "Prescへようこそ",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24),
          ),
        ),
        Container(height: 12),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            "Prescはプレゼンテーション、講演会、スピーチなどで使用できる原稿表示アプリです。",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[800]),
          ),
        ),
        SizedBox(height: 48),
      ],
    );
  }

  Widget _page2() {
    return _explanationPage(
      imagePath: "assets/images/screenshot/home.png",
      title: "原稿を管理",
      content: "原稿を追加・編集・削除しましょう。作った原稿はタグを付けて整理することができます。",
    );
  }

  Widget _page3() {
    return _explanationPage(
      imagePath: "assets/images/screenshot/playback.png",
      title: "原稿を再生",
      content: "出来た原稿を再生できます。音声認識により、どこまで話したかが一目で分かります。",
    );
  }

  Widget _page4() {
    return _explanationPage(
      imagePath: "assets/images/screenshot/setting.png",
      title: "自由にカスタマイズ",
      content: "書式の向き（縦書き、横書き）や文字の色、フォントサイズ等は自由にカスタマイズ可能です。",
    );
  }

  Widget _explanationPage(
      {@required String imagePath,
      @required String title,
      @required String content}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 4),
        Expanded(
          child: Image.asset(imagePath),
        ),
        SizedBox(height: 12),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24),
          ),
        ),
        SizedBox(height: 8),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            content,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[800]),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
