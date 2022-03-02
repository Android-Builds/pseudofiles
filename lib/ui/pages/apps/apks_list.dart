import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/utils/constants.dart';

import '../../widgets/apk_icon.dart';

class ApksList extends StatefulWidget {
  const ApksList({Key? key}) : super(key: key);

  @override
  State<ApksList> createState() => _ApksListState();
}

class _ApksListState extends State<ApksList> {
  static List<dynamic> allApps = [];

  Future<dynamic> getApps() async {
    if (allApps.isEmpty) {
      allApps = await FileManager.getApkFromStorage();
    }
    return allApps;
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
              File file = File(apps[index]);
              FileStat fileStat = file.statSync();
              return ListTile(
                onTap: () async => await OpenFile.open(file.path),
                leading: AppIcon(
                  path: apps[index],
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
