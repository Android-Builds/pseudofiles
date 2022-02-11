import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pseudofiles/classes/enums/operation_enum.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/utils/constants.dart';
import 'package:pseudofiles/widgets/directory_list_tile.dart';
import 'package:pseudofiles/widgets/file_list_tile.dart';

class ActionButtonsBar extends StatefulWidget {
  const ActionButtonsBar({Key? key}) : super(key: key);

  @override
  _ActionButtonsBarState createState() => _ActionButtonsBarState();
}

class _ActionButtonsBarState extends State<ActionButtonsBar> {
  Future<void> showClipboardContents() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clipboard Contents'),
          content: SingleChildScrollView(
            child: ListBody(
              children: List.generate(
                  FileManager.selectedFilesForOperation.value.length, (index) {
                List<FileSystemEntity> list =
                    FileManager.selectedFilesForOperation.value;
                if (list[index] is File) {
                  return FileListTile(
                    entity: list[index],
                    oneTapAction: (value) {},
                    longPressAction: (value) {},
                    showColor: false,
                  );
                } else {
                  return DirectoryListTile(
                    entity: list[index],
                    oneTapAction: (value) {},
                    longPressAction: (value) {},
                    showColor: false,
                  );
                }
              }),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Future<void> confirmDeleteDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              'Delete ${FileManager.getEntityCount(FileManager.selectedFiles.value.length)}'),
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
                FileManager.operationType = OperationType.delete;
                FileManager.deleteEntities();
                Navigator.of(context).pop();
                FileManager.reloadPath();
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
        valueListenable: FileManager.selectedFilesForOperation,
        builder: (context, value, child) {
          List<FileSystemEntity> list = value as List<FileSystemEntity>;
          return Container(
            height: size.height * 0.08,
            width: size.width,
            margin: const EdgeInsets.all(20.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: FileManager.useMaterial3
                  ? Theme.of(context).colorScheme.surfaceVariant
                  : Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: FittedBox(
              child: list.isNotEmpty
                  ? Row(
                      children: [
                        navBarIcon(Icons.paste, () {
                          FileManager.cutOrCopyFilesAndDirs(
                              FileManager.operationType);
                        }),
                        navBarIcon(Icons.create_new_folder_outlined, () {}),
                        navBarIcon(Icons.task, () {
                          showClipboardContents();
                        }),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        navBarIcon(Icons.copy, () {
                          FileManager.operationType = OperationType.copye;
                          FileManager.selectedFilesForOperation.value =
                              List.from(FileManager.selectedFiles.value);
                        }),
                        navBarIcon(Icons.cut, () {
                          FileManager.operationType = OperationType.move;
                          FileManager.selectedFilesForOperation.value =
                              List.from(FileManager.selectedFiles.value);
                        }),
                        navBarIcon(Icons.delete, () {
                          confirmDeleteDialog();
                        }),
                        ValueListenableBuilder(
                          valueListenable: FileManager.selectedFiles,
                          builder: (_, value, child) =>
                              (value as List<FileSystemEntity>).length == 1
                                  ? navBarIcon(Icons.edit, () {})
                                  : const SizedBox.shrink(),
                        ),
                        navBarIcon(Icons.share, () {}),
                        navBarIcon(Icons.select_all, () async {
                          List<FileSystemEntity> list =
                              await FileManager.getDirectories();
                          if (FileManager.selectedFiles.value.length ==
                              list.length) {
                            FileManager.selectedFiles.value =
                                List.from(FileManager.selectedFiles.value)
                                  ..clear();
                          } else {
                            FileManager.selectedFiles.value =
                                List.from(FileManager.selectedFiles.value)
                                  ..clear();
                            FileManager.selectedFiles.value =
                                List.from(FileManager.selectedFiles.value)
                                  ..addAll(list);
                          }
                        }),
                        navBarIcon(Icons.more_vert, () {}),
                      ],
                    ),
            ),
          );
        });
  }

  Widget navBarIcon(IconData icon, Function onTap) => IconButton(
        onPressed: () => onTap(),
        icon: Icon(
          icon,
          size: size.width * 0.05,
        ),
      );
}
