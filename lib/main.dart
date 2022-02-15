import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pseudofiles/bloc/theme_bloc/theme_bloc.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/ui/pages/onboarding/onboarding_home.dart';
import 'package:pseudofiles/utils/themes.dart';

import 'ui/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('prefs');
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

  Widget app() {
    //TODO: Hive called here
    final bool firstLaunch = Hive.box('prefs').get('firstLaunch') ?? true;
    FileManager.useMaterial3 = Hive.box('prefs').get('useMaterial3') ?? false;
    FileManager.useCompactUi = Hive.box('prefs').get('useCompactUi') ?? false;
    FileManager.keepNavbarHidden =
        Hive.box('prefs').get('keepNavbarHidden') ?? false;
    FileManager.themeMode =
        ThemeMode.values.byName(Hive.box('prefs').get('themeMode') ?? 'system');
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      themeMode: FileManager.themeMode,
      theme: FileManager.useMaterial3 ? lightThemeExp : lightTheme,
      darkTheme: FileManager.useMaterial3 ? darkThemeExp : darkTheme,
      //home: const HomePage(),
      home: firstLaunch ? const OnboardingHome() : const HomePage(),
    );
  }
}
