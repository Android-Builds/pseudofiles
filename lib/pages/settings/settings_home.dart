import 'package:flutter/material.dart';
import 'package:pseudofiles/utils/themes.dart';
import 'package:pseudofiles/widgets/custom_switch.dart';

class SettingsHome extends StatefulWidget {
  const SettingsHome({Key? key}) : super(key: key);

  @override
  _SettingsHomeState createState() => _SettingsHomeState();
}

class _SettingsHomeState extends State<SettingsHome> {
  bool _enabled = false;
  @override
  Widget build(BuildContext context) {
    List colorList = Theme.of(context).colorScheme.toString().split(',');
    print(darkScheme);
    print(Theme.of(context).colorScheme);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              CustomSwitch(
                value: _enabled,
                onChanged: (bool val) {
                  setState(() {
                    _enabled = val;
                  });
                },
              ),
              Wrap(
                children: List.generate(colorList.length, (index) {
                  String colorString = colorList[index]
                      .split(':')
                      .last
                      .split('(')
                      .last
                      .replaceAll(')', '');
                  Color color = Colors.red;
                  if (!colorString.contains('Brightness')) {
                    color = Color(int.parse(colorString));
                  }
                  BorderRadius radius = BorderRadius.zero;
                  if (Theme.of(context).scaffoldBackgroundColor == color) {
                    radius = BorderRadius.circular(20.0);
                  }
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: radius,
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(colorString),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
