import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/utils/constants.dart';
import 'package:pseudofiles/utils/themes.dart';

class DirectoryListTile extends StatelessWidget {
  const DirectoryListTile({
    Key? key,
    required this.entity,
    required this.manager,
    required this.oneTapAction,
    required this.longPressAction,
    this.showColor = true,
  }) : super(key: key);

  final FileSystemEntity entity;
  final FileManager manager;
  final Function oneTapAction;
  final Function longPressAction;
  final bool showColor;

  @override
  Widget build(BuildContext context) {
    FileStat fileStat = entity.statSync();
    return ListTile(
      tileColor: showColor &&
              manager.selectedFiles.value
                  .any((element) => element.path == entity.path)
          ? accentColor.withOpacity(0.2)
          : null,
      onLongPress: () => longPressAction(entity),
      onTap: () => oneTapAction(entity),
      leading: CircleAvatar(
        radius: 23.0,
        backgroundColor: accentColor,
        foregroundColor: Theme.of(context).textTheme.bodyText1!.color,
        child: const Icon(Icons.folder),
      ),
      title: Text(FileManager.getFileName(entity)),
      subtitle: Row(
        children: [
          EntityCountText(manager: manager, directory: entity as Directory),
          const Spacer(),
          Text(
            manager.getDate(fileStat.modified),
            style: TextStyle(fontSize: size.width * 0.025),
          )
        ],
      ),
    );
  }
}

class EntityCountText extends StatelessWidget {
  const EntityCountText({
    Key? key,
    required this.manager,
    required this.directory,
  }) : super(key: key);
  final FileManager manager;
  final Directory directory;

  Future getCount() async {
    return directory.list().length;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCount(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(
            manager.getEntityCount(snapshot.data as int),
            style: TextStyle(fontSize: size.width * 0.025),
          );
        }
        return const Text('');
      },
    );
  }
}
