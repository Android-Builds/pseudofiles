import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pseudofiles/classes/enums/operation_enum.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/utils/constants.dart';
import 'package:pseudofiles/widgets/directory_list_tile.dart';
import 'package:pseudofiles/widgets/file_list_tile.dart';

class ActionButtonsBar extends StatefulWidget {
  const ActionButtonsBar({Key? key, required this.manager}) : super(key: key);
  final FileManager manager;

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
                  widget.manager.selectedFilesForOperation.value.length,
                  (index) {
                List<FileSystemEntity> list =
                    widget.manager.selectedFilesForOperation.value;
                if (list[index] is File) {
                  return FileListTile(
                    entity: list[index],
                    manager: widget.manager,
                    oneTapAction: (value) {},
                    longPressAction: (value) {},
                    showColor: false,
                  );
                } else {
                  return DirectoryListTile(
                    entity: list[index],
                    manager: widget.manager,
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
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                //manager.deleteEntity();
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
        valueListenable: widget.manager.selectedFilesForOperation,
        builder: (context, value, child) {
          List<FileSystemEntity> list = value as List<FileSystemEntity>;
          return Container(
            height: size.height * 0.08,
            width: size.width * (list.isEmpty ? 0.8 : 0.4),
            margin: const EdgeInsets.all(20.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: FittedBox(
              child: list.isNotEmpty
                  ? Row(
                      children: [
                        navBarIcon(Icons.paste, () {
                          widget.manager.cutOrCopyFilesAndDirs(
                              widget.manager.operationType);
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
                          widget.manager.operationType = OperationType.copye;
                          widget.manager.selectedFilesForOperation.value =
                              List.from(widget.manager.selectedFiles.value);
                        }),
                        navBarIcon(Icons.cut, () {
                          widget.manager.operationType = OperationType.move;
                          widget.manager.selectedFilesForOperation.value =
                              List.from(widget.manager.selectedFiles.value);
                        }),
                        navBarIcon(Icons.delete, () {
                          widget.manager.operationType = OperationType.delete;
                          widget.manager.deleteEntities();
                          widget.manager.reloadPath();
                        }),
                        widget.manager.selectedFiles.value.length == 1
                            ? navBarIcon(Icons.edit, () {})
                            : const SizedBox.shrink(),
                        navBarIcon(Icons.share, () {}),
                        navBarIcon(Icons.select_all, () async {
                          List<FileSystemEntity> list = await widget.manager
                              .getDirectories(sortTypes.name);
                          if (widget.manager.selectedFiles.value.length ==
                              list.length) {
                            widget.manager.selectedFiles.value =
                                List.from(widget.manager.selectedFiles.value)
                                  ..clear();
                          } else {
                            widget.manager.selectedFiles.value =
                                List.from(widget.manager.selectedFiles.value)
                                  ..clear();
                            widget.manager.selectedFiles.value =
                                List.from(widget.manager.selectedFiles.value)
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
