import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pseudofiles/pages/home_page.dart';
import 'package:pseudofiles/utils/themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool darkMode =
        SchedulerBinding.instance!.window.platformBrightness == Brightness.dark;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor:
          darkMode ? darkScheme.background : lightScheme.background,
      systemNavigationBarIconBrightness:
          darkMode ? Brightness.light : Brightness.dark,
    ));
    //accentColor = darkMode ? darkScheme.secondary : lightScheme.secondary;
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: lightThemeExp,
      darkTheme: darkThemeExp,
      home: const HomePage(),
    );
  }
}
