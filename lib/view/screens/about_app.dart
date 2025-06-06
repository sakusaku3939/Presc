import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:presc/generated/l10n.dart';
import 'package:presc/view/utils/ripple_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/color_constants.dart';

class AboutAppScreen extends StatelessWidget {
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
                  height: 56,
                  child: RippleIconButton(
                    Icons.close,
                    size: 32,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(top: 64),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: 400,
                          ),
                          child: Image.asset(
                            "assets/images/logo.png",
                            width: MediaQuery.of(context).size.width * 0.5,
                          ),
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
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  width: double.infinity,
                  height: 40,
                  child: TextButton(
                    child: Text(S.current.privacyPolicy),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[800],
                    ),
                    onPressed: () => launchUrl(
                      Uri.parse(
                        "https://github.com/sakusaku3939/Presc/blob/master/Privacy-Policy.md",
                      ),
                      mode: LaunchMode.externalApplication,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    child: Text(S.current.sendFeedback),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstants.mainColor,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => launchUrl(
                      Uri.parse(
                        "https://docs.google.com/forms/d/e/1FAIpQLSe0FIJcyyJiQ6jR1p8-hXj_UicsgPWCFszEh9T82f3kAOhnMg/viewform",
                      ),
                      mode: LaunchMode.externalApplication,
                    ),
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
