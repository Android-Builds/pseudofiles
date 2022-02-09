import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/classes/enums/media_enum.dart';
import 'package:pseudofiles/pages/pictures/pictures_grid_page.dart';
import 'package:pseudofiles/utils/constants.dart';

class PicturesPage extends StatefulWidget {
  const PicturesPage({Key? key}) : super(key: key);

  @override
  _PicturesPageState createState() => _PicturesPageState();
}

class _PicturesPageState extends State<PicturesPage> {
  static List<dynamic> allImages = [];

  Future<dynamic> getImages() async {
    if (allImages.isEmpty) {
      allImages = await FileManager.getAllMedias(MediaType.image);
    }
    return allImages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pictures'),
      ),
      body: FutureBuilder(
        future: getImages(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List imageList = snapshot.data as List;
            return GridView.builder(
              padding: const EdgeInsets.all(10.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
              ),
              itemCount: imageList.length,
              itemBuilder: (context, index) {
                Map map = imageList[index] as Map;
                List val = map.values.elementAt(0);
                return InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PicturesViewGrid(
                          pictureList: val,
                          title: map.keys.first,
                        ),
                      )),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: FittedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.file(
                              File(val[0]),
                              height: size.height * 0.25,
                              width: size.width * 0.5,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(map.keys.first, maxLines: 1),
                          const SizedBox(height: 5.0),
                          Text(
                            getText(map.values.elementAt(0).length),
                            style: TextStyle(
                              fontSize: size.width * 0.03,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
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

  getText(int count) {
    if (count == 1) {
      return '1 item';
    } else {
      return '$count items';
    }
  }
}
