import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/about_page.dart';
import 'pages/tutorial_page.dart';
import 'pages/scan_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: HomePage(),

      routes: {
        '/home': (_) => HomePage(),
        '/about': (_) => AboutPage(),
        '/tutorial': (_) => TutorialPage(),
        '/scan': (_) => ScanPage(),
      },
    );
  }
}
