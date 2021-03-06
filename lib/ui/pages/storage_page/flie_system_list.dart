import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file/open_file.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/utils/constants.dart';
import 'package:pseudofiles/utils/themes.dart';

import '../../../bloc/getFiles_bloc/getfiles_bloc.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/directory_list_tile.dart';
import '../../widgets/file_list_tile.dart';
import '../../widgets/persistant_header.dart';

class FileSystemEntityList extends StatefulWidget {
  const FileSystemEntityList({
    Key? key,
    required this.list,
    this.isArchivePage = false,
  }) : super(key: key);

  final List<FileSystemEntity> list;
  final bool isArchivePage;

  @override
  State<FileSystemEntityList> createState() => _FileSystemEntityListState();
}

class _FileSystemEntityListState extends State<FileSystemEntityList> {
  //List<FileSystemEntity> FileManagerr.selectedFiles = [];
  late ScrollController scrollController;

  void selectedFilesListener() {
    if (FileManager.selectedFiles.value.isEmpty ||
        FileManager.selectedFiles.value.isNotEmpty) {
      setState(() {});
    }
  }

  void currentPathListener() {
    if (FileManager.getStoragePageScrollController()
            .position
            .hasContentDimensions &&
        FileManager.getStoragePageScrollController().offset !=
            FileManager.getStoragePageScrollController().initialScrollOffset) {
      FileManager.getStoragePageScrollController().jumpTo(
        FileManager.getStoragePageScrollController().initialScrollOffset,
      );
    }
  }

  @override
  void initState() {
    FileManager.selectedFiles.addListener(selectedFilesListener);
    scrollController = ScrollController();
    FileManager.currentPath.addListener(currentPathListener);
    super.initState();
  }

  @override
  void dispose() {
    FileManager.selectedFiles.removeListener(selectedFilesListener);
    FileManager.currentPath.removeListener(currentPathListener);
    super.dispose();
  }

  bool presentInList(List<FileSystemEntity> list, FileSystemEntity entity) {
    return list.any((element) => element.path == entity.path);
  }

  void selectOrRemoveEntity(FileSystemEntity entity) {
    if (presentInList(FileManager.selectedFiles.value, entity)) {
      FileManager.selectedFiles.value =
          List.from(FileManager.selectedFiles.value)
            ..removeWhere((element) => element.path == entity.path);
    } else {
      FileManager.selectedFiles.value =
          List.from(FileManager.selectedFiles.value)..add(entity);
    }
  }

  void openEntity(FileSystemEntity entity) async {
    if (entity is Directory) {
      FileManager.changeDirectory(entity.path);
      BlocProvider.of<GetfilesBloc>(context).add(const GetAllFiles());
    } else {
      await OpenFile.open(entity.path);
    }
  }

  void oneTapAction(FileSystemEntity entity) async {
    if (FileManager.selectedFilesForOperation.value.isNotEmpty) {
      if (presentInList(FileManager.selectedFilesForOperation.value, entity)) {
        return;
      } else {
        openEntity(entity);
      }
    } else {
      if (FileManager.selectedFiles.value.isNotEmpty) {
        selectOrRemoveEntity(entity);
      } else {
        openEntity(entity);
      }
    }
    setState(() {});
  }

  void longPressAction(FileSystemEntity entity) {
    if (FileManager.selectedFilesForOperation.value.isEmpty &&
        FileManager.selectedFiles.value.isEmpty) {
      FileManager.selectedFiles.value =
          List.from(FileManager.selectedFiles.value)..add(entity);
    } else {
      return;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        controller: FileManager.getStoragePageScrollController(),
        slivers: [
          !widget.isArchivePage
              ? SliverPersistentHeader(
                  delegate: PersistentHeader(widget: const CustomAppBar()),
                )
              : const SliverToBoxAdapter(child: SizedBox.shrink()),
          SliverPersistentHeader(
            pinned: true,
            delegate: PersistentHeader(
              height: size.height * 0.06,
              widget: Container(
                width: size.width,
                color: Theme.of(context).scaffoldBackgroundColor,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: FileManager.getDirectoryNames(
                    isArchive: widget.isArchivePage,
                  ).length,
                  itemBuilder: (context, index) {
                    List<String> dirNames = FileManager.getDirectoryNames(
                        isArchive: widget.isArchivePage);
                    if (scrollController.positions.last.hasContentDimensions &&
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
                            if (dirNames[index] == 'Internal' ||
                                dirNames[index] == 'SD Card') {
                              FileManager.goToRootDirectory();
                            } else {
                              FileManager.goToDirectory(dirNames[index]);
                            }
                            BlocProvider.of<GetfilesBloc>(context)
                                .add(const GetAllFiles());
                          },
                          child: Text(
                            dirNames[index],
                            style: TextStyle(
                              color:
                                  dirNames[index] == FileManager.getCurrentDir()
                                      ? FileManager.useMaterial3
                                          ? null
                                          : accentColor
                                      : Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color,
                              fontSize: size.width * 0.04,
                            ),
                          ),
                        ),
                        index == dirNames.length - 1
                            ? const SizedBox.shrink()
                            : const Icon(Icons.arrow_right),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index == 0) {
                  return ListTile(
                    onTap: () async {
                      if (widget.isArchivePage &&
                          Directory(FileManager.currentPath.value)
                              .parent
                              .path
                              .endsWith('cache')) {
                        return;
                      }
                      await FileManager.goToParentDirectory();
                      BlocProvider.of<GetfilesBloc>(context)
                          .add(const GetAllFiles());
                    },
                    leading: CircleAvatar(
                      backgroundColor: FileManager.useMaterial3
                          ? Theme.of(context).colorScheme.primary
                          : accentColor,
                      foregroundColor: FileManager.useMaterial3
                          ? Theme.of(context).colorScheme.background
                          : Theme.of(context).textTheme.bodyText1!.color,
                      radius: 23.0,
                      child: const Icon(Icons.folder),
                    ),
                    title: const Text('...'),
                  );
                } else {
                  if (widget.list[index - 1] is File) {
                    return FileListTile(
                      entity: widget.list[index - 1],
                      oneTapAction: oneTapAction,
                      longPressAction: longPressAction,
                    );
                  } else {
                    return DirectoryListTile(
                      entity: widget.list[index - 1],
                      oneTapAction: oneTapAction,
                      longPressAction: longPressAction,
                    );
                  }
                }
              },
              childCount: widget.list.length + 1,
            ),
          )
        ],
      ),
    );
  }
}
