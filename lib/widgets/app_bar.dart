import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/utils/constants.dart';
import 'package:pseudofiles/widgets/custom_animated_icon.dart';

import 'menu.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    this.bottom,
    this.height = kToolbarHeight,
  }) : super(key: key);
  final PreferredSizeWidget? bottom;
  final double height;
  static bool isOpen = true;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: StatefulBuilder(
        builder: (_, setState) {
          return IconButton(
            icon: ValueListenableBuilder(
              valueListenable: FileManager.selectedFiles,
              builder: (context, value, child) {
                return CustomAnimatedIcon(
                  isOpen: (value as List<FileSystemEntity>).isEmpty,
                  icon1: Icons.menu,
                  icon2: Icons.close,
                );
              },
            ),
            onPressed: () {
              if (FileManager.selectedFiles.value.isEmpty) {
                FileManager.globalKey.currentState!.openDrawer();
              } else {
                FileManager.selectedFiles.value =
                    FileManager.selectedFilesForOperation.value =
                        List.from(FileManager.selectedFiles.value)..clear();
                setState(() => isOpen = !isOpen);
              }
            },
          );
        },
      ),
      title: ValueListenableBuilder(
        valueListenable: FileManager.currentPath,
        builder: (context, value, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(FileManager.getCurrentDir()),
            FutureBuilder(
              future: FileManager.getFilesAndFolderCount(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    snapshot.data as String,
                    style: TextStyle(fontSize: size.width * 0.025),
                  );
                }
                return const Text('');
              },
            ),
          ],
        ),
      ),
      actions: const [Menu()],
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
