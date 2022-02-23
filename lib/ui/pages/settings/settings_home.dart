import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:pseudofiles/classes/file_manager.dart';

import '../../../bloc/theme_bloc/theme_bloc.dart';
import 'custom_switch.dart';

class SettingsHome extends StatefulWidget {
  const SettingsHome({Key? key}) : super(key: key);

  @override
  _SettingsHomeState createState() => _SettingsHomeState();
}

class _SettingsHomeState extends State<SettingsHome> {
  bool _enabled = false;
  final prefBox = Hive.box('prefs');
  @override
  Widget build(BuildContext context) {
    List colorList = Theme.of(context).colorScheme.toString().split(',');
    print(Theme.of(context).colorScheme);
    // print(Theme.of(context).colorScheme);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BlocProvider<ThemeBloc>(
              create: (context) => ThemeBloc(),
              child: SwitchListTile(
                title: const Text('Use Material 3 Theme'),
                value: FileManager.useMaterial3,
                onChanged: (value) async {
                  //TODO: Hive called here
                  prefBox.put('useMaterial3', value);
                  setState(() => FileManager.useMaterial3 = value);
                  await Future.delayed(const Duration(milliseconds: 200));
                  BlocProvider.of<ThemeBloc>(context).add(ChangeTheme(value));
                },
              ),
            ),
            BlocProvider<ThemeBloc>(
              create: (context) => ThemeBloc(),
              child: SwitchListTile(
                title: const Text('Use Compact Ui'),
                value: FileManager.useCompactUi,
                onChanged: (value) async {
                  prefBox.put('useCompactUi', value);
                  setState(() => FileManager.useCompactUi = value);
                  await Future.delayed(const Duration(milliseconds: 200));
                  BlocProvider.of<ThemeBloc>(context)
                      .add(ChangeCompactness(value));
                },
              ),
            ),
            BlocProvider<ThemeBloc>(
              create: (context) => ThemeBloc(),
              child: SwitchListTile(
                title: const Text('Hide Bottom Navbar'),
                value: FileManager.keepNavbarHidden,
                onChanged: (value) async {
                  prefBox.put('keepNavbarHidden', value);
                  setState(() => FileManager.keepNavbarHidden = value);
                  await Future.delayed(const Duration(milliseconds: 200));
                  BlocProvider.of<ThemeBloc>(context)
                      .add(HideBottomNavbar(value));
                },
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  FileManager.getDynamicColors();
                },
                child: const Text('Get Colors')),
            CustomSwitch(
              value: _enabled,
              onChanged: (bool val) {
                setState(() {
                  _enabled = val;
                });
              },
            ),
            // Wrap(
            //   children: List.generate(colorList.length, (index) {
            //     String colorString = colorList[index]
            //         .split(':')
            //         .last
            //         .split('(')
            //         .last
            //         .replaceAll(')', '');
            //     Color color = Colors.red;
            //     if (!colorString.contains('Brightness')) {
            //       color = Color(int.parse(colorString));
            //     }
            //     BorderRadius radius = BorderRadius.zero;
            //     if (Theme.of(context).scaffoldBackgroundColor == color) {
            //       radius = BorderRadius.circular(20.0);
            //     }
            //     return Padding(
            //       padding: const EdgeInsets.all(10.0),
            //       child: Column(
            //         children: [
            //           Container(
            //             width: 50,
            //             height: 50,
            //             decoration: BoxDecoration(
            //               color: color,
            //               borderRadius: radius,
            //               border: Border.all(
            //                 color: Colors.black,
            //               ),
            //             ),
            //           ),
            //           const SizedBox(height: 10),
            //           Text(colorString),
            //         ],
            //       ),
            //     );
            //   }),
            // ),
          ],
        ),
      ),
    );
  }
}
