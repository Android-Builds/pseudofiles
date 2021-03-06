import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pseudofiles/bloc/theme_bloc/theme_bloc.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/ui/pages/onboarding/onboarding_home.dart';
import 'package:pseudofiles/utils/constants.dart';
import 'package:pseudofiles/utils/themes.dart';

import 'bloc/getFiles_bloc/getfiles_bloc.dart';
import 'ui/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('prefs');
  await Hive.openBox('searchSuggestions');
  Map map = await FileManager.getDynamicColors();
  runApp(MyApp(colorsMap: map));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.colorsMap}) : super(key: key);
  final Map colorsMap;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          create: (context) => ThemeBloc(),
        ),
        BlocProvider<GetfilesBloc>(
          create: (context) => GetfilesBloc(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return app(colorsMap);
        },
      ),
    );
  }

  Widget app(Map colorsMap) {
    //TODO: Hive called here
    final bool firstLaunch = Hive.box('prefs').get('firstLaunch') ?? true;
    suggestions =
        (Hive.box('searchSuggestions').get('suggestions') ?? "").split(',');
    FileManager.useMaterial3 = Hive.box('prefs').get('useMaterial3') ?? false;
    FileManager.useCompactUi = Hive.box('prefs').get('useCompactUi') ?? false;
    FileManager.keepNavbarHidden =
        Hive.box('prefs').get('keepNavbarHidden') ?? false;
    FileManager.themeMode =
        ThemeMode.values.byName(Hive.box('prefs').get('themeMode') ?? 'system');
    return MaterialApp(
      title: 'PseudoFiles',
      debugShowCheckedModeBanner: false,
      themeMode: FileManager.themeMode,
      theme: FileManager.useMaterial3
          ? lightThemeExp(Color(int.parse('0x${colorsMap['systemLight']}')))
          : lightTheme,
      darkTheme: FileManager.useMaterial3
          ? darkThemeExp(Color(int.parse('0x${colorsMap['systemDark']}')))
          : darkTheme,
      home: firstLaunch ? const OnboardingHome() : const HomePage(),
    );
  }
}
