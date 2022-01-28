import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideosViewGrid extends StatelessWidget {
  const VideosViewGrid({
    Key? key,
    required this.title,
    required this.videoList,
  }) : super(key: key);
  final String title;
  final List videoList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: GridView.builder(
        itemCount: videoList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) => InkWell(
          onTap: () => OpenFile.open(videoList[index]),
          child: Container(
            margin: const EdgeInsets.all(5.0),
            color: Colors.grey,
            child: ThumbnailImage(videoPath: videoList[index]),
          ),
        ),
      ),
    );
  }
}

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
