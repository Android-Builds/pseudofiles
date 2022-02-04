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
  late ScrollController scrollController;

  void listener() {
    if (widget.manager.selectedFiles.value.isEmpty ||
        widget.manager.selectedFiles.value.isNotEmpty) {
      setState(() {});
    }
  }

  @override
  void initState() {
    widget.manager.selectedFiles.addListener(listener);
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    widget.manager.selectedFiles.removeListener(listener);
    super.dispose();
  }

  bool presentInList(List<FileSystemEntity> list, FileSystemEntity entity) {
    return list.any((element) => element.path == entity.path);
  }

  void selectOrRemoveEntity(FileSystemEntity entity) {
    if (presentInList(widget.manager.selectedFiles.value, entity)) {
      widget.manager.selectedFiles.value =
          List.from(widget.manager.selectedFiles.value)
            ..removeWhere((element) => element.path == entity.path);
    } else {
      widget.manager.selectedFiles.value =
          List.from(widget.manager.selectedFiles.value)..add(entity);
    }
  }

  void openEntity(FileSystemEntity entity) async {
    if (entity is Directory) {
      widget.manager.changeDirectory(entity.path);
    } else {
      await OpenFile.open(entity.path);
    }
  }

  void oneTapAction(FileSystemEntity entity) async {
    if (widget.manager.selectedFilesForOperation.value.isNotEmpty) {
      if (presentInList(
          widget.manager.selectedFilesForOperation.value, entity)) {
        return;
      } else {
        openEntity(entity);
      }
    } else {
      if (widget.manager.selectedFiles.value.isNotEmpty) {
        selectOrRemoveEntity(entity);
      } else {
        openEntity(entity);
      }
    }
    setState(() {});
  }

  void longPressAction(FileSystemEntity entity) {
    if (widget.manager.selectedFilesForOperation.value.isEmpty &&
        widget.manager.selectedFiles.value.isEmpty) {
      widget.manager.selectedFiles.value =
          List.from(widget.manager.selectedFiles.value)..add(entity);
    } else {
      return;
    }
    setState(() {});
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
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.manager.getDirectoryNames().length,
                    itemBuilder: (context, index) {
                      if (scrollController
                              .positions.last.hasContentDimensions &&
                          scrollController.offset <
                              scrollController.position.maxScrollExtent) {
                        scrollController.animateTo(
                          scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.fastOutSlowIn,
                        );
                      }
                      return Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              if (widget.manager.getDirectoryNames()[index] ==
                                      'Internal' ||
                                  widget.manager.getDirectoryNames()[index] ==
                                      'SD Card') {
                                widget.manager.goToRootDirectory();
                              } else {
                                widget.manager.goToParentDirectory();
                              }
                            },
                            child: Text(
                              widget.manager.getDirectoryNames()[index],
                              style: TextStyle(
                                color:
                                    widget.manager.getDirectoryNames()[index] ==
                                            widget.manager.getCurrentDir()
                                        ? accentColor
                                        : Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .color,
                                fontSize: size.width * 0.035,
                              ),
                            ),
                          ),
                          index == widget.manager.getDirectoryNames().length - 1
                              ? const SizedBox.shrink()
                              : const Icon(Icons.arrow_right),
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
