import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/utils/constants.dart';
import 'package:pseudofiles/utils/themes.dart';

import 'directory_list_tile.dart';
import 'file_list_tile.dart';

class FileSystemEntityList extends StatefulWidget {
  const FileSystemEntityList({
    Key? key,
    required this.list,
    required this.manager,
  }) : super(key: key);

  final List<FileSystemEntity> list;
  final FileManager manager;

  @override
  State<FileSystemEntityList> createState() => _FileSystemEntityListState();
}

class _FileSystemEntityListState extends State<FileSystemEntityList> {
  //List<FileSystemEntity> widget.manager.selectedFiles = [];

  void oneTapAction(FileSystemEntity entity) async {
    if (widget.manager.selectedFiles.value.isEmpty) {
      if (entity is Directory) {
        widget.manager.changeDirectory(entity.path);
      } else {
        await OpenFile.open(entity.path);
      }
    } else {
      if (widget.manager.selectedFiles.value
          .any((element) => element.path == entity.path)) {
        widget.manager.selectedFiles.value =
            List.from(widget.manager.selectedFiles.value)
              ..removeWhere((element) => element.path == entity.path);
      } else {
        widget.manager.selectedFiles.value =
            List.from(widget.manager.selectedFiles.value)..add(entity);
      }
    }
    setState(() {});
  }

  void longPressAction(FileSystemEntity entity) {
    if (widget.manager.selectedFiles.value.isEmpty) {
      widget.manager.selectedFiles.value =
          List.from(widget.manager.selectedFiles.value)..add(entity);
    } else {
      return;
    }
    setState(() {});
  }

  List<String> getDirectoryNames() {
    List<String> pathSplit =
        widget.manager.currentPath.value.split(Platform.pathSeparator);
    if (widget.manager.currentPath.value.contains('0')) {
      pathSplit = pathSplit.sublist(4, pathSplit.length);
      pathSplit.insert(0, 'Internal');
    } else {
      pathSplit = pathSplit.sublist(3, pathSplit.length);
      pathSplit.insert(0, 'SD Card');
    }
    return pathSplit;
  }

  String getCurrentDir() {
    List<String> pathSplit =
        widget.manager.currentPath.value.split(Platform.pathSeparator);
    if (widget.manager.currentPath.value.contains('0')) {
      pathSplit = pathSplit.sublist(4, pathSplit.length);
      pathSplit.insert(0, 'Internal');
    } else {
      pathSplit = pathSplit.sublist(3, pathSplit.length);
      pathSplit.insert(0, 'SD Card');
    }
    return pathSplit.last;
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      isAlwaysShown: true,
      interactive: true,
      showTrackOnHover: true,
      radius: const Radius.circular(10.0),
      controller: FileManager.getStoragePageScrollController(),
      child: ListView.builder(
        controller: FileManager.getStoragePageScrollController(),
        shrinkWrap: true,
        itemCount: widget.list.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.height * 0.05,
                  width: size.width,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: getDirectoryNames().length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              if (getDirectoryNames()[index] == 'Internal' ||
                                  getDirectoryNames()[index] == 'SD Card') {
                                widget.manager.goToRootDirectory();
                              } else {
                                widget.manager.goToParentDirectory();
                              }
                            },
                            child: Text(
                              getDirectoryNames()[index],
                              style: TextStyle(
                                color: getDirectoryNames()[index] ==
                                        getCurrentDir()
                                    ? accentColor
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color,
                              ),
                            ),
                          ),
                          index == getDirectoryNames().length - 1
                              ? const SizedBox.shrink()
                              : const Icon(Icons.arrow_right_sharp),
                        ],
                      );
                    },
                  ),
                ),
                const Divider(thickness: 2),
                ListTile(
                  onTap: () {
                    widget.manager.goToParentDirectory();
                  },
                  leading: CircleAvatar(
                    backgroundColor: accentColor,
                    foregroundColor:
                        Theme.of(context).textTheme.bodyText1!.color,
                    radius: 23.0,
                    child: const Icon(Icons.folder),
                  ),
                  title: const Text('...'),
                ),
              ],
            );
          } else {
            if (widget.list[index - 1] is File) {
              return FileListTile(
                entity: widget.list[index - 1],
                manager: widget.manager,
                oneTapAction: oneTapAction,
                longPressAction: longPressAction,
              );
            } else {
              return DirectoryListTile(
                entity: widget.list[index - 1],
                manager: widget.manager,
                oneTapAction: oneTapAction,
                longPressAction: longPressAction,
              );
            }
          }
        },
      ),
    );
  }
}
