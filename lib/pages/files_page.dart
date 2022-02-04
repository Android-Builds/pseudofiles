import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/widgets/flie_system_list.dart';

class FilesPage extends StatefulWidget {
  const FilesPage({Key? key, required this.manager}) : super(key: key);

  final FileManager manager;

  @override
  _FilesPageState createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> {
  static bool isFirst = true;

  Future<bool> _onWillPop() async {
    if (!(await widget.manager.isRootDirectory())) {
      widget.manager.goToParentDirectory();
    } else {
      return (await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you want to exit ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        ),
      ));
    }
    return false;
  }

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
    return widget.manager.getDirectories(sortTypes.name);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: ValueListenableBuilder(
          valueListenable: widget.manager.currentPath,
          builder: (BuildContext context, value, Widget? child) {
            return FutureBuilder(
              future: getDirs(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<FileSystemEntity> list =
                      snapshot.data as List<FileSystemEntity>;
                  return FileSystemEntityList(
                    list: list,
                    manager: widget.manager,
                  );
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
      ),
    );
  }
}
