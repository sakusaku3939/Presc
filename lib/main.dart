import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:presc/view/app_screen.dart';
import 'package:provider/provider.dart';
import 'package:presc/provider/bottom_navigation_bar_provider.dart';

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
          primaryColor: Colors.deepOrange[400],
          accentColor: Colors.deepOrange[400],
        ),
        home: AppScreen());
  }
}
