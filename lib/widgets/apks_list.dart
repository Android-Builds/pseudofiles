import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/utils/constants.dart';
import 'package:pseudofiles/utils/themes.dart';

class ApksList extends StatefulWidget {
  const ApksList({Key? key, required this.manager}) : super(key: key);
  final FileManager manager;

  @override
  State<ApksList> createState() => _ApksListState();
}

class _ApksListState extends State<ApksList> {
  List<dynamic> allApps = [];
  List<APK> allAPKs = [];

  Future<dynamic> getApps() async {
    await Future.delayed(const Duration(seconds: 2), () async {});
    if (allApps.isEmpty) {
      allApps = await widget.manager.getApkFromStorage();
      for (var element in allApps) {
        allAPKs.add(APK(element, Uint8List.fromList([])));
      }
    }
    return allAPKs;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getApps(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List apps = snapshot.data as List;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: 5.0,
              vertical: 10.0,
            ),
            itemCount: apps.length,
            itemBuilder: (context, index) {
              TextStyle subtytleStyle = TextStyle(
                fontSize: size.width * 0.025,
                color: Colors.grey,
              );
              File file = File(apps[index].path);
              FileStat fileStat = file.statSync();
              return ListTile(
                onTap: () async => await OpenFile.open(file.path),
                leading: AppIcon(
                  manager: widget.manager,
                  path: apps[index].path,
                  apk: apps[index],
                ),
                title: Text(widget.manager.getFileName(file)),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.manager.getSize(fileStat.size),
                      style: subtytleStyle,
                    ),
                    Text(
                      widget.manager.getDate(fileStat.modified),
                      style: subtytleStyle,
                    ),
                  ],
                ),
              );
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

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

class APK {
  String path;
  Uint8List image;

  APK(this.path, this.image);
}
