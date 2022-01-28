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
  }) : super(key: key);

  final FileSystemEntity entity;
  final FileManager manager;
  final Function oneTapAction;
  final Function longPressAction;

  @override
  Widget build(BuildContext context) {
    List<FileSystemEntity> listEntity = manager.getAllFiles(entity.path);
    FileStat fileStat = entity.statSync();
    return ListTile(
      tileColor: manager.selectedFiles.value
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
      title: Text(manager.getFileName(entity)),
      subtitle: Row(
        children: [
          Text(
            manager.getEntityCount(listEntity.length),
            style: TextStyle(fontSize: size.width * 0.025),
          ),
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
