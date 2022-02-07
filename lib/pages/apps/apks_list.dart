import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:pseudofiles/classes/apk.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/utils/constants.dart';
import 'package:pseudofiles/widgets/apk_icon.dart';

class ApksList extends StatefulWidget {
  const ApksList({Key? key}) : super(key: key);

  @override
  State<ApksList> createState() => _ApksListState();
}

class _ApksListState extends State<ApksList> {
  List<dynamic> allApps = [];
  List<APK> allAPKs = [];

  Future<dynamic> getApps() async {
    await Future.delayed(const Duration(seconds: 2), () async {});
    if (allApps.isEmpty) {
      allApps = await FileManager.getApkFromStorage();
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
                  path: apps[index].path,
                  apk: apps[index],
                ),
                title: Text(FileManager.getFileName(file)),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      FileManager.getSize(fileStat.size),
                      style: subtytleStyle,
                    ),
                    Text(
                      FileManager.getDate(fileStat.modified),
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
