import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:presc/view/screens/manuscript.dart';
import 'package:provider/provider.dart';
import 'package:presc/viewModel/bottom_navigation_bar_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (context) => BottomNavigationBarProvider()),
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
