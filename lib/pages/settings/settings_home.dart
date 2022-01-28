import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Row(
        children: [
          // Switch(
          //   inactiveTrackColor: Colors.red,
          //   value: _enabled,
          //   onChanged: (bool val) {
          //     setState(() {
          //       _enabled = val;
          //     });
          //   },
          // ),
          CustomSwitch(
            value: _enabled,
            onChanged: (bool val) {
              setState(() {
                _enabled = val;
              });
            },
          ),
        ],
      ),
    );
  }
}
