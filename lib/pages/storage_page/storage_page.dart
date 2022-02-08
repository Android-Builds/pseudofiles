import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/pages/storage_page/files_page.dart';
import 'package:pseudofiles/utils/constants.dart';
import 'package:pseudofiles/utils/themes.dart';
import 'package:pseudofiles/widgets/app_drawer.dart';
import 'package:pseudofiles/widgets/floating_button_menu.dart';
import 'package:pseudofiles/widgets/ongoing_task_overlay.dart';

class StoragePage extends StatefulWidget {
  const StoragePage({Key? key}) : super(key: key);

  @override
  State<StoragePage> createState() => _StoragePageState();
}

class _StoragePageState extends State<StoragePage> {
  @override
  void initState() {
    getPermissions();
    super.initState();
  }

  TextEditingController controller = TextEditingController();
  UnderlineInputBorder borderStyle =
      UnderlineInputBorder(borderSide: BorderSide(color: accentColor));

  Future<void> _createFileOrFolderDialog(String type) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SizedBox(
          child: AlertDialog(
            insetPadding: EdgeInsets.zero,
            contentPadding: const EdgeInsets.only(
              top: 20.0,
              left: 25.0,
              right: 25.0,
              bottom: 10.0,
            ),
            buttonPadding: const EdgeInsets.all(5.0),
            title: Text('Create a $type'),
            content: SizedBox(
              width: size.width * 0.75,
              child: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Input a name to create a $type'),
                    TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        border: borderStyle,
                        focusedBorder: borderStyle,
                        enabledBorder: borderStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  controller.clear();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  if (type == 'file') {
                    FileManager.createFile(controller.text);
                  } else {
                    FileManager.createDirectory(controller.text);
                  }
                  controller.clear();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  getPermissions() async {
    Permission permission = Permission.manageExternalStorage;
    var status = await permission.status;
    if (status.isDenied) {
      status = await permission.request();
    }
    //if (await Permission.location.isRestricted) {}
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      key: FileManager.globalKey,
      drawer: const AppDrawer(),
      body: ValueListenableBuilder(
        valueListenable: FileManager.taskFile,
        builder: (context, value, child) {
          if (value == 'none') {
            return Stack(
              alignment: Alignment.center,
              children: const [
                FilesPage(),
                SizedBox.shrink(),
              ],
            );
          } else {
            return Stack(
              children: const [
                AbsorbPointer(child: FilesPage()),
                Align(
                  alignment: Alignment.center,
                  child: OngoingTaskOverlay(),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: ValueListenableBuilder(
          valueListenable: FileManager.selectedFiles,
          builder: (context, value, child) {
            List<FileSystemEntity> list = value as List<FileSystemEntity>;
            return list.isEmpty
                ? FloatingButtonMenu(
                    items: [
                      FloatingButtonMenuButton('File', Icons.file_copy, () {
                        _createFileOrFolderDialog('file');
                        //setState(() {});
                      }),
                      FloatingButtonMenuButton('Folder', Icons.folder, () {
                        _createFileOrFolderDialog('folder');
                        //setState(() {});
                      }),
                    ],
                  )
                : const SizedBox.shrink();
          }),
    );
  }
}