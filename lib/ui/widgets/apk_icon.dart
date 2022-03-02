import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/utils/constants.dart';
import 'package:pseudofiles/utils/themes.dart';

class AppIcon extends StatefulWidget {
  const AppIcon({
    Key? key,
    required this.path,
    this.isCompact = false,
  }) : super(key: key);
  final String path;
  final bool isCompact;

  @override
  _AppIconState createState() => _AppIconState();
}

class _AppIconState extends State<AppIcon> {
  Future<dynamic> getAppIcon() async {
    if (appIcons[widget.path] == null) {
      Map map = await FileManager.getApkDetails(widget.path);
      if (map['icon'] != null) {
        appIcons[widget.path] = map['icon'];
      }
    }
    return appIcons[widget.path];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAppIcon(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Uint8List icon = snapshot.data as Uint8List;
          return icon.isNotEmpty
              ? !widget.isCompact
                  ? Image.memory(
                      icon,
                      width: size.width * 0.12,
                    )
                  : Image.memory(icon)
              : defaultIcon();
        }
        return defaultIcon();
      },
    );
  }

  Widget defaultIcon() => !widget.isCompact
      ? CircleAvatar(
          radius: size.width * 0.06,
          backgroundColor: FileManager.useMaterial3
              ? Theme.of(context).colorScheme.primary
              : accentColor,
          foregroundColor: FileManager.useMaterial3
              ? Theme.of(context).colorScheme.background
              : Theme.of(context).textTheme.bodyText1!.color,
          child: const FaIcon(FontAwesomeIcons.android),
        )
      : const FaIcon(FontAwesomeIcons.android);
}
