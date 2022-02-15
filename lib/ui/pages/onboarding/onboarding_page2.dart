import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/utils/themes.dart';

import '../../../bloc/theme_bloc/theme_bloc.dart';
import '../../../utils/constants.dart';

class OnboardingPage2 extends StatefulWidget {
  const OnboardingPage2({
    Key? key,
    required this.onboardingPageController,
  }) : super(key: key);
  final PageController onboardingPageController;

  @override
  State<OnboardingPage2> createState() => _OnboardingPage2State();
}

class _OnboardingPage2State extends State<OnboardingPage2> {
  final prefBox = Hive.box('prefs');
  void onPressed(ThemeMode themeMode) {
    setState(() {
      FileManager.themeMode = themeMode;
    });
    //TODO: Hive Called here
    prefBox.put('themeMode', themeMode.name);
    BlocProvider.of<ThemeBloc>(context).add(ChangeThemeMode(themeMode));
  }

  ButtonStyle getButtonStyle(ThemeMode themeMode) {
    return ButtonStyle(
      backgroundColor: FileManager.themeMode == themeMode
          ? (FileManager.useMaterial3
              ? MaterialStateColor.resolveWith(
                  (states) => Theme.of(context).colorScheme.secondary)
              : MaterialStateColor.resolveWith((states) => accentColor))
          : null,
      foregroundColor: FileManager.themeMode == themeMode
          ? (FileManager.useMaterial3
              ? MaterialStateColor.resolveWith(
                  (states) => Theme.of(context).colorScheme.surfaceVariant)
              : MaterialStateColor.resolveWith(
                  (states) => Theme.of(context).textTheme.bodyText1!.color!))
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeBloc(),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            SvgPicture.asset(
              'assets/palatte.svg',
              color: accentColor,
              height: 100,
              width: 100,
            ),
            const SizedBox(height: 50.0),
            Text(
              'Select Theme !',
              style: TextStyle(
                fontSize: size.width * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        style: getButtonStyle(ThemeMode.light),
                        onPressed: () => onPressed(ThemeMode.light),
                        child: const Text('Light')),
                    TextButton(
                        style: getButtonStyle(ThemeMode.dark),
                        onPressed: () => onPressed(ThemeMode.dark),
                        child: const Text('Dark')),
                    TextButton(
                        style: getButtonStyle(ThemeMode.system),
                        onPressed: () => onPressed(ThemeMode.system),
                        child: const Text('System')),
                  ],
                );
              },
            ),
            const SizedBox(height: 20.0),
            CheckboxListTile(
                tristate: false,
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text('Use Material 3 Theme'),
                value: FileManager.useMaterial3,
                onChanged: (value) {
                  setState(() => FileManager.useMaterial3 = value!);
                  //TODO: Hive Called here
                  prefBox.put('useMaterial3', value);
                  BlocProvider.of<ThemeBloc>(context).add(ChangeTheme(value!));
                }),
            const SizedBox(height: 100.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    widget.onboardingPageController.animateToPage(2,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.bounceInOut);
                  },
                  child: const Text('Next'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
