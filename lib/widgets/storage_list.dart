import 'dart:io';

import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/pages/storage_page/storage_page.dart';
import 'package:pseudofiles/utils/constants.dart';
import 'package:pseudofiles/utils/themes.dart';

class StorageList extends StatelessWidget {
  const StorageList({Key? key, required this.manager}) : super(key: key);
  final FileManager manager;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height * 0.2,
      child: FutureBuilder(
        future: manager.getRootDirectories(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<FileSystemEntity> rootDirs =
                snapshot.data as List<FileSystemEntity>;
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: rootDirs.length,
              itemBuilder: (context, index) {
                List<FileSystemEntity> listEntity =
                    Directory(rootDirs[index].path).listSync();
                FileStat fileStat = rootDirs[index].statSync();
                return ListTile(
                  onTap: () {
                    manager.currentPath.value = rootDirs[index].path;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StoragePage(manager: manager),
                        ));
                  },
                  leading: CircleAvatar(
                    radius: 23.0,
                    backgroundColor: accentColor,
                    foregroundColor:
                        Theme.of(context).textTheme.bodyText1!.color,
                    child: const Icon(Icons.folder),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        index == 0 ? 'Internal' : 'SD Card',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        rootDirs[index].path,
                        style: TextStyle(
                          fontSize: size.width * 0.02,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                    ],
                  ),
                  // subtitle: Row(
                  //   children: [
                  //     Text(
                  //       manager.getEntityCount(listEntity.length),
                  //       style: TextStyle(fontSize: size.width * 0.025),
                  //     ),
                  //     const Spacer(),
                  //     Text(
                  //       manager.getDate(fileStat.modified),
                  //       style: TextStyle(fontSize: size.width * 0.025),
                  //     )
                  //   ],
                  // ),
                  subtitle: Column(
                    children: [
                      LinearPercentIndicator(
                        percent: 0.5,
                        lineHeight: 7.0,
                        progressColor: accentColor,
                        backgroundColor: accentColor.withOpacity(0.4),
                        trailing: Text('50%'),
                      )
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
      ),
    );
  }
}
