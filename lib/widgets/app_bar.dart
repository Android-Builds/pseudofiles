import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/utils/themes.dart';

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

  Future<void> _confirmDeleteDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              'Delete ${manager.getEntityCount(manager.selectedFiles.value.length)}'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure you want to delete them permanently ?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                manager.deleteEntity();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: manager.selectedFiles,
      builder: (context, value, child) {
        List<FileSystemEntity> list = value as List<FileSystemEntity>;
        return list.isEmpty
            ? AppBar(
                title: const Text('Filesss'),
                actions: [
                  Menu(manager: manager),
                ],
              )
            : AppBar(
                title: const Text('Files'),
                actions: [
                  IconButton(
                    onPressed: () {
                      _confirmDeleteDialog(context)
                          .then((value) => manager.reloadPath());
                    },
                    icon: const Icon(Icons.delete),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.select_all,
                      color: list.isEmpty ? Colors.grey : accentColor,
                    ),
                  ),
                  Menu(manager: manager),
                ],
                bottom: bottom,
              );
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
