import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pseudofiles/classes/file_manager.dart';

import 'flie_system_list.dart';

class FilesPage extends StatefulWidget {
  const FilesPage({Key? key}) : super(key: key);

  @override
  _FilesPageState createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> {
  static bool isFirst = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    isFirst = true;
    super.dispose();
  }

  Future getDirs() async {
    if (isFirst) {
      await Future.delayed(const Duration(milliseconds: 1000));
      isFirst = false;
    }
    return FileManager.getDirectories();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: ValueListenableBuilder(
        valueListenable: FileManager.currentPath,
        builder: (BuildContext context, value, Widget? child) {
          return FutureBuilder(
            future: getDirs(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<FileSystemEntity> list =
                    snapshot.data as List<FileSystemEntity>;
                return FileSystemEntityList(list: list);
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                const Center(child: Text('Error'));
              }
              return const Center(child: CircularProgressIndicator());
            },
          );
        },
      ),
    );
  }
}
