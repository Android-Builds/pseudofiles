import 'dart:io';

import 'package:flutter/material.dart';

import '../../../classes/file_manager.dart';
import '../../widgets/directory_list_tile.dart';

class StorageList extends StatelessWidget {
  const StorageList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FileManager.getRootDirectories(),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          List<Directory> rootDirs = snapshot.data as List<Directory>;
          return Column(
            children: List.generate(rootDirs.length + 1, (index) {
              String dirName = '';
              if (index == 1) {
                dirName = 'Internal Storage';
              } else {
                dirName = 'SD Card';
              }
              return index == 0
                  ? const ListTile(
                      dense: true,
                      title: Text(
                        'Storages',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  : DirectoryListTile(
                      dirName: dirName,
                      entity: rootDirs[index - 1],
                      oneTapAction: (entity) {
                        FileManager.changeDirectory(rootDirs[index].path);
                        FileManager.changeDirectory(rootDirs[index].path);
                        FileManager.pageController.animateToPage(
                          1,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.bounceInOut,
                        );
                      },
                      longPressAction: (entity) {},
                    );
            }),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
