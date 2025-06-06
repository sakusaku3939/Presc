import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:presc/view/screens/manuscript.dart';
import 'package:presc/view/screens/onboarding.dart';
import 'package:presc/viewModel/editable_tag_item_provider.dart';
import 'package:presc/viewModel/manuscript_edit_provider.dart';
import 'package:presc/viewModel/manuscript_provider.dart';
import 'package:presc/viewModel/manuscript_tag_provider.dart';
import 'package:presc/viewModel/onboarding_provider.dart';
import 'package:presc/viewModel/playback_provider.dart';
import 'package:presc/viewModel/playback_timer_provider.dart';
import 'package:presc/viewModel/playback_visualizer_provider.dart';
import 'package:presc/viewModel/speech_to_text_provider.dart';
import 'package:provider/provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/color_config.dart';
import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light, // for iOS
      statusBarIconBrightness: Brightness.dark, // for Android
    ),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => OnBoardingProvider()),
        ChangeNotifierProvider(create: (context) => ManuscriptProvider()),
        ChangeNotifierProvider(create: (context) => ManuscriptEditProvider()),
        ChangeNotifierProvider(
          create: (context) => EditableTagItemProvider(),
        ),
        ChangeNotifierProvider(create: (context) => ManuscriptTagProvider()),
        ChangeNotifierProvider(create: (context) => PlaybackProvider()),
        ChangeNotifierProvider(create: (context) => SpeechToTextProvider()),
        ChangeNotifierProvider(
          create: (context) => PlaybackVisualizerProvider(),
        ),
        ChangeNotifierProvider(create: (context) => PlaybackTimerProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription? _intentDataStreamSubscription;

  @override
  void initState() {
    super.initState();
    _intentDataStreamSubscription = ReceiveSharingIntent.instance.getMediaStream().listen(
      receiveShareText,
      onError: (err) {
        print("getLinkStream error: $err");
      },
    );
    ReceiveSharingIntent.instance.getInitialMedia().then(receiveShareText);
  }

  @override
  void dispose() {
    _intentDataStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Presc',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.white,
        splashColor: Platform.isIOS ? Colors.transparent : null,
        splashFactory: Platform.isIOS ? NoSplash.splashFactory : null,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
          iconTheme: IconThemeData(color: ColorConfig.iconColor),
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
        ),
        bottomSheetTheme: BottomSheetThemeData(
          surfaceTintColor: Colors.transparent,
        ),
        dialogTheme: DialogThemeData(
          surfaceTintColor: Colors.transparent,
        ),
        drawerTheme: DrawerThemeData(
          surfaceTintColor: Colors.transparent,
        ),
        popupMenuTheme: PopupMenuThemeData(
          surfaceTintColor: Colors.transparent,
        ),
      ),
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: FutureBuilder(
        future: _isFirstLaunch(),
        builder: (context, snapshot) {
          if (snapshot.data == null)
            return Container(color: ColorConfig.backgroundColor);
          if (snapshot.data == true) {
            return OnBoardingScreen();
          } else {
            return ManuscriptScreen();
          }
        },
      ),
    );
  }

  Future<bool> _isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isFirstLaunch") ?? true;
  }

  Future<void> receiveShareText(List<SharedMediaFile>? value) async {
    if (value == null || value.isEmpty) return;

    if (value.first.type == SharedMediaType.text) {
      final text = value.first.path;

      if (text.isNotEmpty) {
        final script = context.read<ManuscriptProvider>();
        final tag = context.read<ManuscriptTagProvider>();
        final id = await script.addScript(title: "", content: text);

        await script.updateScriptTable();
        await tag.loadTag(memoId: id);
      }
    }
  }
}
