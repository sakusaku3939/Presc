import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:presc/provider/bottom_navigation_bar_provider.dart';

import 'package:presc/view/screens/manuscript.dart';
import 'package:presc/view/screens/library.dart';

class AppScreen extends StatefulWidget {
  static const String routeName = '/app';

  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  var currentTab = [
    ManuscriptScreen(title: '原稿一覧'),
    LibraryScreen(title: 'ライブラリ'),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomNavigationBar =
        Provider.of<BottomNavigationBarProvider>(context);

    return Scaffold(
      body: currentTab[bottomNavigationBar.currentIndex],
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: Container(
      //   decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(32),
      //     boxShadow: [
      //       BoxShadow(
      //         color: Theme.of(context).primaryColor,
      //         offset: const Offset(0, 2),
      //         blurRadius: 14,
      //       ),
      //     ],
      //   ),
      //   child: FloatingActionButton(
      //     elevation: 0,
      //     child: SvgPicture.asset(
      //       'assets/images/pencil.svg',
      //       color: Colors.white,
      //     ),
      //     onPressed: () {},
      //   ),
      // ),
      // bottomNavigationBar: BottomNavigationBar(
      //   showSelectedLabels: false,
      //   showUnselectedLabels: false,
      //   backgroundColor: Colors.white,
      //   currentIndex: bottomNavigationBar.currentIndex,
      //   selectedFontSize: 4,
      //   unselectedFontSize: 4,
      //   onTap: (index) {
      //     bottomNavigationBar.currentIndex = index;
      //   },
      //   type: BottomNavigationBarType.fixed,
      //   items: [
      //     BottomNavigationBarItem(
      //         icon: navigationIcon(
      //           'assets/images/note.svg',
      //           isActive: false,
      //         ),
      //         activeIcon: navigationIcon(
      //           'assets/images/note.svg',
      //           isActive: true,
      //         ),
      //         label: "原稿一覧"),
      //     BottomNavigationBarItem(
      //         icon: navigationIcon(
      //           'assets/images/grid.svg',
      //           isActive: false,
      //         ),
      //         activeIcon: navigationIcon(
      //           'assets/images/grid.svg',
      //           isActive: true,
      //         ),
      //         label: "ライブラリ"),
      //   ],
      // ),
    );
  }

  // Widget navigationIcon(String asset, {bool isActive}) {
  //   return SvgPicture.asset(
  //     asset,
  //     height: 26,
  //     color: isActive ? Theme.of(context).primaryColor : Colors.grey,
  //   );
  // }
}
