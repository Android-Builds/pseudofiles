import 'dart:io';

import 'package:flutter/material.dart';

class ImageView extends StatefulWidget {
  const ImageView({
    Key? key,
    required this.imagePath,
    required this.title,
  }) : super(key: key);
  final String imagePath;
  final String title;

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Hero(
          tag: widget.title,
          child: Image.file(File(widget.imagePath)),
        ),
      ),
    );
  }
}
