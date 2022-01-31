import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:pseudofiles/widgets/thumbnail_image.dart';

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
