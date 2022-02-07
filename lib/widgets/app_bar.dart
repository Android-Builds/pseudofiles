import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/utils/constants.dart';
import 'package:pseudofiles/widgets/custom_animated_icon.dart';

import 'menu.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    required this.manager,
    this.bottom,
    this.height = kToolbarHeight,
  }) : super(key: key);
  final FileManager manager;
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
              valueListenable: manager.selectedFiles,
              builder: (context, value, child) {
                return CustomAnimatedIcon(
                  isOpen: (value as List<FileSystemEntity>).isEmpty,
                  icon1: Icons.menu,
                  icon2: Icons.close,
                );
              },
            ),
            onPressed: () {
              if (manager.selectedFiles.value.isEmpty) {
                manager.globalKey.currentState!.openDrawer();
              } else {
                manager.selectedFiles.value = manager.selectedFilesForOperation
                    .value = List.from(manager.selectedFiles.value)..clear();
                setState(() => isOpen = !isOpen);
              }
            },
          );
        },
      ),
      title: ValueListenableBuilder(
        valueListenable: manager.currentPath,
        builder: (context, value, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(manager.getCurrentDir()),
            FutureBuilder(
              future: manager.getFilesAndFolderCount(),
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
      actions: [
        Menu(manager: manager),
      ],
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
