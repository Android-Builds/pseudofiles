import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pseudofiles/pages/pictures/image_view.dart';

class PicturesViewGrid extends StatelessWidget {
  const PicturesViewGrid({
    Key? key,
    required this.pictureList,
    required this.title,
  }) : super(key: key);
  final String title;
  final List pictureList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: GridView.builder(
        itemCount: pictureList.length,
        // scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(10.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) => InkWell(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ImageView(
                        imagePath: pictureList[index],
                        title: pictureList[index].toString().split('/').last,
                      ))),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Hero(
              tag: pictureList[index].toString().split('/').last,
              child: Image.file(
                File(pictureList[index]),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
