import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pseudofiles/classes/apk.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/utils/constants.dart';
import 'package:pseudofiles/utils/themes.dart';

class AppIcon extends StatefulWidget {
  const AppIcon({
    Key? key,
    required this.manager,
    required this.path,
    required this.apk,
  }) : super(key: key);
  final FileManager manager;
  final String path;
  final APK apk;

  @override
  _AppIconState createState() => _AppIconState();
}

class _AppIconState extends State<AppIcon> {
  Future<dynamic> getAppIcon() async {
    if (widget.apk.image.isEmpty) {
      Map map = await widget.manager.getApkDetails(widget.path);
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
              ? CircleAvatar(
                  radius: size.width * 0.06,
                  backgroundImage: MemoryImage(apk.image),
                )
              : defaultIcon();
        }
        return defaultIcon();
      },
    );
  }

  Widget defaultIcon() => CircleAvatar(
        radius: size.width * 0.06,
        backgroundColor: accentColor,
        foregroundColor: Theme.of(context).textTheme.bodyText1!.color,
        child: const Icon(FontAwesomeIcons.android),
      );
}
