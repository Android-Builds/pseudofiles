import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pseudofiles/classes/apk.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/utils/constants.dart';
import 'package:pseudofiles/utils/themes.dart';
import 'package:pseudofiles/widgets/apk_icon.dart';
import 'package:pseudofiles/widgets/thumbnail_image.dart';

class FileListTile extends StatelessWidget {
  const FileListTile({
    Key? key,
    required this.entity,
    required this.oneTapAction,
    required this.longPressAction,
    this.showColor = true,
  }) : super(key: key);

  final FileSystemEntity entity;
  final Function oneTapAction;
  final Function longPressAction;
  final bool showColor;

  Widget getIcon(IconData iconData) {
    return Icon(iconData);
  }

  getThumbnail() {
    return CircleAvatar(
      radius: size.width * 0.06,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: ThumbnailImage(videoPath: entity.path),
          ),
          Icon(
            FontAwesomeIcons.play,
            size: size.width * 0.05,
          )
        ],
      ),
    );
  }

  getImage(BuildContext context) {
    return CircleAvatar(
      radius: size.width * 0.06,
      backgroundColor: accentColor,
      foregroundColor: Theme.of(context).textTheme.bodyText1!.color,
      backgroundImage: FileImage(
        File(entity.path),
      ),
    );
  }

  getIconWidget(BuildContext context, IconData iconData) {
    return CircleAvatar(
      radius: size.width * 0.06,
      backgroundColor: accentColor,
      foregroundColor: Theme.of(context).textTheme.bodyText1!.color,
      child: Icon(iconData),
    );
  }

  Widget getLeadingIcon(BuildContext context, String? type) {
    print(type);
    switch (type) {
      case 'vnd.android.package-archive':
        return AppIcon(
          path: entity.path,
          apk: APK(entity.path, Uint8List.fromList([])),
        );
      case 'image':
        return getImage(context);
      case 'pdf':
        return getIconWidget(context, FontAwesomeIcons.solidFilePdf);
      case 'json':
        return getIconWidget(context, FontAwesomeIcons.solidFileCode);
      case 'zip':
        return getIconWidget(context, FontAwesomeIcons.solidFileArchive);
      case 'audio':
        return getIconWidget(context, FontAwesomeIcons.solidFileAudio);
      case 'video':
        return getThumbnail();
      default:
        return getIconWidget(context, FontAwesomeIcons.solidFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    FileStat fileStat = entity.statSync();
    return ListTile(
      tileColor: showColor &&
              FileManager.selectedFiles.value
                  .any((element) => element.path == entity.path)
          ? accentColor.withOpacity(0.2)
          : null,
      onLongPress: () => longPressAction(entity),
      onTap: () => oneTapAction(entity),
      leading: getLeadingIcon(context, FileManager.getMimeType(entity.path)),
      title: Text(FileManager.getFileName(entity)),
      subtitle: Row(
        children: [
          Text(
            FileManager.getSize(fileStat.size),
            style: TextStyle(fontSize: size.width * 0.025),
          ),
          const Spacer(),
          Text(
            FileManager.getDate(fileStat.modified),
            style: TextStyle(fontSize: size.width * 0.025),
          )
        ],
      ),
    );
  }
}
