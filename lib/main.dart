import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:presc/view/screens/manuscript.dart';
import 'package:presc/viewModel/editable_tag_item_provider.dart';
import 'package:presc/viewModel/manuscript_provider.dart';
import 'package:presc/viewModel/manuscript_tag_provider.dart';
import 'package:presc/viewModel/playback_provider.dart';
import 'package:presc/viewModel/playback_timer_provider.dart';
import 'package:presc/viewModel/playback_visualizer_provider.dart';
import 'package:presc/viewModel/speech_to_text_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (context) => ManuscriptProvider()),
          ChangeNotifierProvider(
              create: (context) => EditableTagItemProvider()),
          ChangeNotifierProvider(
              create: (context) => ManuscriptTagProvider()),
          ChangeNotifierProvider(
              create: (context) => PlaybackProvider()),
          ChangeNotifierProvider(
              create: (context) => SpeechToTextProvider()),
          ChangeNotifierProvider(
              create: (context) => PlaybackVisualizerProvider()),
          ChangeNotifierProvider(
              create: (context) => PlaybackTimerProvider()),
        ],
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Presc',
        theme: ThemeData(
          primaryColor: Colors.white,
          accentColor: Colors.deepOrange[400],
        ),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('ja', ''),
        ],
        home: ManuscriptScreen());
  }
}
