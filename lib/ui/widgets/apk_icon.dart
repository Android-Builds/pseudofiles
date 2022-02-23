import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pseudofiles/classes/apk.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/utils/constants.dart';
import 'package:pseudofiles/utils/themes.dart';

class AppIcon extends StatefulWidget {
  const AppIcon({
    Key? key,
    required this.path,
    required this.apk,
    this.isCompact = false,
  }) : super(key: key);
  final String path;
  final APK apk;
  final bool isCompact;

  @override
  _AppIconState createState() => _AppIconState();
}

class _AppIconState extends State<AppIcon> {
  Future<dynamic> getAppIcon() async {
    if (widget.apk.image.isEmpty) {
      Map map = await FileManager.getApkDetails(widget.path);
      if (map['icon'] != null) {
        widget.apk.image = map['icon'];
      }
    }
    return widget.apk;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAppIcon(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          APK apk = snapshot.data as APK;
          return apk.image.isNotEmpty
              ? !widget.isCompact
                  ? CircleAvatar(
                      radius: size.width * 0.06,
                      backgroundImage: MemoryImage(apk.image),
                    )
                  : Image.memory(apk.image)
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
          child: const Icon(FontAwesomeIcons.android),
        )
      : const Icon(FontAwesomeIcons.android);
}
