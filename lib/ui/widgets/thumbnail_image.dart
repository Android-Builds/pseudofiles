import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ThumbnailImage extends StatefulWidget {
  const ThumbnailImage({Key? key, required this.videoPath}) : super(key: key);

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
          return Image.memory(
            snapshot.data,
            fit: BoxFit.cover,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
