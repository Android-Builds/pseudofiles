import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/classes/enums/media_enum.dart';
import 'package:pseudofiles/ui/pages/videos/vidoes_view_grid.dart';
import 'package:pseudofiles/utils/constants.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideosPage extends StatefulWidget {
  const VideosPage({Key? key}) : super(key: key);

  @override
  _VideosPageState createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  getThumbnail(String videoPath) async {
    Uint8List? thumbNail = await VideoThumbnail.thumbnailData(
      video: videoPath,
      imageFormat: ImageFormat.WEBP,
      maxHeight: 256,
      quality: 100,
    );
    return thumbNail;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Videos'),
      ),
      body: FutureBuilder(
        future: FileManager.getAllMedias(MediaType.video),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List videoList = snapshot.data as List;
            return GridView.builder(
              padding: const EdgeInsets.all(10.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
              ),
              itemCount: videoList.length,
              itemBuilder: (context, index) {
                Map map = videoList[index] as Map;
                List val = map.values.elementAt(0);
                return InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideosViewGrid(
                          title: map.keys.first,
                          videoList: val,
                        ),
                      )),
                  child: FutureBuilder(
                    future: getThumbnail(val[0]),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: FittedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.memory(
                                    snapshot.data,
                                    height: size.height * 0.25,
                                    width: size.width * 0.5,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                Text(map.keys.first, maxLines: 1),
                                const SizedBox(height: 5.0),
                                Text(
                                  getText(val.length),
                                  style: TextStyle(
                                    fontSize: size.width * 0.03,
                                    color: Colors.grey,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: SizedBox(
                                  height: size.height * 0.25,
                                  width: size.width * 0.5,
                                  child: const Icon(FontAwesomeIcons.video),
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              Text(map.keys.first, maxLines: 1),
                              const SizedBox(height: 5.0),
                              Text(
                                getText(val.length),
                                style: TextStyle(
                                  fontSize: size.width * 0.03,
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  String getText(int count) {
    switch (count) {
      case 0:
        return 'Empty';
      case 1:
        return '1 item';
      default:
        return '$count items';
    }
  }
}
