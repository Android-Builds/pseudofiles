import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../utils/constants.dart';

class ThumbnailImage extends StatefulWidget {
  const ThumbnailImage({
    Key? key,
    required this.videoPath,
    this.forTile = false,
  }) : super(key: key);
  final bool forTile;

  final String videoPath;

  @override
  State<ThumbnailImage> createState() => _ThumbnailImageState();
}

class _ThumbnailImageState extends State<ThumbnailImage> {
  late Uint8List thumbNail;
  bool isLoaded = false;

  getThumbnail(String videoPath) async {
    if (!isLoaded) {
      Uint8List? t = await VideoThumbnail.thumbnailData(
        video: videoPath,
        imageFormat: ImageFormat.WEBP,
        maxHeight: 256,
        quality: 100,
      );
      if (t != null) {
        thumbNail = t;
      }
      isLoaded = true;
    }
    return thumbNail;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getThumbnail(widget.videoPath),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return !widget.forTile
              ? Image.memory(
                  snapshot.data,
                  fit: BoxFit.cover,
                )
              : Container(
                  height: size.height * 0.15,
                  width: size.width * 0.3,
                  decoration: BoxDecoration(
                      borderRadius: FileManager.useCompactUi
                          ? BorderRadius.circular(10.0)
                          : null,
                      shape: FileManager.useCompactUi
                          ? BoxShape.rectangle
                          : BoxShape.circle,
                      image: DecorationImage(
                        image: MemoryImage(snapshot.data),
                        fit: BoxFit.cover,
                      )),
                );
        }
        return !FileManager.useCompactUi
            ? const SizedBox.shrink()
            : SizedBox(
                height: size.height * 0.15,
                width: size.width * 0.3,
              );
      },
    );
  }
}
