import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'file_list_tile.dart';

class RecentFiles extends StatelessWidget {
  const RecentFiles({
    Key? key,
    required this.count,
    this.scroll = false,
    required this.isCompact,
  }) : super(key: key);
  final int count;
  final bool scroll;
  final bool isCompact;

  Widget fileList(ScrollController controller, List<String> paths) {
    return Scrollbar(
      isAlwaysShown: scroll,
      interactive: true,
      showTrackOnHover: true,
      radius: const Radius.circular(10.0),
      controller: controller,
      child: ListView.builder(
        shrinkWrap: true,
        controller: controller,
        physics: scroll
            ? const AlwaysScrollableScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        itemCount: paths.length,
        itemBuilder: (BuildContext context, int index) {
          File file = File(paths[index]);
          return FileListTile(
            entity: file,
            isCompact: false,
            oneTapAction: (FileSystemEntity entity) =>
                OpenFile.open(entity.path),
            longPressAction: (FileSystemEntity entity) {},
          );
        },
      ),
    );
  }

  Widget compactList(List<String> paths) {
    return SizedBox(
      height: 200.0,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: paths.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) {
          File file = File(paths[index]);
          return FileListTile(
            entity: file,
            isCompact: true,
            oneTapAction: (FileSystemEntity entity) =>
                OpenFile.open(entity.path),
            longPressAction: (FileSystemEntity entity) {},
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController controller = ScrollController();
    return FutureBuilder(
      future: FileManager.getRecentFiles(count),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<String> paths = snapshot.data as List<String>;
          return isCompact ? compactList(paths) : fileList(controller, paths);
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
