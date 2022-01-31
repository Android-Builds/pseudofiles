import 'package:flutter/material.dart';
import 'package:pseudofiles/pages/home_page.dart';
import 'package:pseudofiles/utils/themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const HomePage(),
    );
  }
}


/**
 * TODO: Declaring a manager and passing it down to the all the child components 
 * down to the last one of them. This can be a pain since the manager can get lost
 * between components and it can be hard to keep track where the manager is and 
 * what the state of the manager is. Need to make the manager static so that the
 * instance of the manager doesn't need to passed around. Same with scroll controller.
 * Need to make a single instance of scrollcontroller that can be used by multiple
 * widgets so that it doesn't need to be passed around through multiple child/parent
 * widgets.
 * */