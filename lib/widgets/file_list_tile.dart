import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/utils/constants.dart';
import 'package:pseudofiles/utils/themes.dart';

class FileListTile extends StatelessWidget {
  const FileListTile({
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

  IconData getLeadingIcon(String? type) {
    print(type);
    switch (type) {
      case 'pdf':
        return FontAwesomeIcons.solidFilePdf;
      case 'json':
        return FontAwesomeIcons.solidFileCode;
      case 'zip':
        return FontAwesomeIcons.solidFileArchive;
      case 'audio':
        return FontAwesomeIcons.solidFileAudio;
      case 'video':
        return FontAwesomeIcons.solidFileVideo;
      default:
        return FontAwesomeIcons.solidFile;
    }
  }

  @override
  Widget build(BuildContext context) {
    FileStat fileStat = entity.statSync();
    return ListTile(
      tileColor: manager.selectedFiles.value
              .any((element) => element.path == entity.path)
          ? accentColor.withOpacity(0.2)
          : null,
      onLongPress: () => longPressAction(entity),
      onTap: () => oneTapAction(entity),
      leading: manager.getMimeType(entity.path) == 'image'
          ? CircleAvatar(
              radius: 23.0,
              backgroundColor: accentColor,
              foregroundColor: Theme.of(context).textTheme.bodyText1!.color,
              backgroundImage: FileImage(
                File(entity.path),
              ),
            )
          : CircleAvatar(
              radius: 23.0,
              backgroundColor: accentColor,
              foregroundColor: Theme.of(context).textTheme.bodyText1!.color,
              child: Icon(getLeadingIcon(manager.getMimeType(entity.path))),
            ),
      title: Text(manager.getFileName(entity)),
      subtitle: Row(
        children: [
          Text(
            '${((fileStat.size) / (1024 * 1024)).toStringAsFixed(2)} mb',
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
