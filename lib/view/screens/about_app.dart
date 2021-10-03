import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:presc/view/utils/ripple_button.dart';

class AboutApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  height: 48,
                  margin: EdgeInsets.only(right: 4),
                  child: RippleIconButton(
                    Icons.close,
                    size: 32,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 64),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/logo.png",
                          width: MediaQuery.of(context).size.width * 0.5,
                        ),
                        SizedBox(height: 16),
                        FutureBuilder(
                          future: () async {
                            final info = await PackageInfo.fromPlatform();
                            return info.version;
                          }(),
                          builder: (context, snapshot) {
                            if (snapshot.data == null)
                              return Container();
                            else
                              return Text("Ver. ${snapshot.data}");
                          },
                        ),
                        SizedBox(height: 16),
                        Text(
                          "© sakusaku3939",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    child: Text("フィードバックを送る"),
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).accentColor,
                      onPrimary: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                ),
                SizedBox(height: 24),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
