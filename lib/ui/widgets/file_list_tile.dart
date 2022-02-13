import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:pseudofiles/classes/apk.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/ui/widgets/thumbnail_image.dart';
import 'package:pseudofiles/utils/constants.dart';
import 'package:pseudofiles/utils/themes.dart';

import 'apk_icon.dart';

class FileListTile extends StatelessWidget {
  const FileListTile({
    Key? key,
    required this.entity,
    required this.oneTapAction,
    required this.longPressAction,
    this.showColor = true,
    this.isCompact = false,
  }) : super(key: key);

  final FileSystemEntity entity;
  final Function oneTapAction;
  final Function longPressAction;
  final bool showColor;
  final bool isCompact;

  Widget getIcon(IconData iconData) {
    return Icon(iconData);
  }

  getThumbnail() {
    Widget child = Stack(
      alignment: Alignment.center,
      children: [
        ThumbnailImage(
          videoPath: entity.path,
          forTile: true,
        ),
        Icon(
          FontAwesomeIcons.play,
          size: size.width * 0.05,
        )
      ],
    );
    return !isCompact
        ? CircleAvatar(
            radius: size.width * 0.06,
            child: child,
          )
        : child;
  }

  getImage(BuildContext context) {
    return !isCompact
        ? CircleAvatar(
            radius: size.width * 0.06,
            backgroundColor: FileManager.useMaterial3
                ? Theme.of(context).colorScheme.secondary
                : accentColor,
            foregroundColor: Theme.of(context).textTheme.bodyText1!.color,
            backgroundImage: FileImage(
              File(entity.path),
            ),
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.file(
              File(entity.path),
              height: size.height * 0.15,
              width: size.width * 0.3,
              fit: BoxFit.cover,
            ),
          );
  }

  getIconWidget(BuildContext context, IconData iconData) {
    return !isCompact
        ? CircleAvatar(
            radius: size.width * 0.06,
            backgroundColor: FileManager.useMaterial3
                ? Theme.of(context).colorScheme.secondary
                : accentColor,
            foregroundColor: FileManager.useMaterial3
                ? Theme.of(context).colorScheme.background
                : Theme.of(context).textTheme.bodyText1!.color,
            child: Icon(iconData),
          )
        : Icon(
            iconData,
            size: size.width * 0.27,
          );
  }

  Widget getLeadingIcon(BuildContext context, String? type) {
    print(type);
    switch (type) {
      case 'vnd.android.package-archive':
        return AppIcon(
          path: entity.path,
          isCompact: isCompact,
          apk: APK(entity.path, Uint8List.fromList([])),
        );
      case 'image':
        return getImage(context);
      case 'vnd.openxmlformats-officedocument.wordprocessingml.document':
        return getIconWidget(context, FontAwesomeIcons.solidFileWord);
      case 'vnd.openxmlformats-officedocument.presentationml.presentation':
        return getIconWidget(context, FontAwesomeIcons.solidFilePowerpoint);
      case 'x-font-ttf':
        return getIconWidget(context, FontAwesomeIcons.font);
      case 'pdf':
        return getIconWidget(context, FontAwesomeIcons.solidFilePdf);
      case 'text':
        return getIconWidget(context, FontAwesomeIcons.solidFileAlt);
      case 'xml':
        return getIconWidget(context, FontAwesomeIcons.solidFileCode);
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

  Widget tileWidget(BuildContext context) {
    FileStat fileStat = entity.statSync();
    return ListTile(
      tileColor: showColor &&
              FileManager.selectedFiles.value
                  .any((element) => element.path == entity.path)
          ? (FileManager.useMaterial3
                  ? Theme.of(context).colorScheme.secondary
                  : accentColor)
              .withOpacity(0.2)
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

  Widget cardWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        OpenFile.open(entity.path);
      },
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            children: [
              getLeadingIcon(context, FileManager.getMimeType(entity.path)),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  FileManager.getFileName(entity),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width * 0.3,
      child: isCompact ? cardWidget(context) : tileWidget(context),
    );
  }
}
