import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pseudofiles/bloc/theme_bloc/theme_bloc.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/pages/home_page.dart';
import 'package:pseudofiles/utils/themes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeBloc>(
      create: (context) => ThemeBloc(),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return app();
        },
      ),
    );
  }

  Widget app() => MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: FileManager.useMaterial3 ? lightThemeExp : lightTheme,
        darkTheme: FileManager.useMaterial3 ? darkThemeExp : darkTheme,
        home: const HomePage(),
      );
}
