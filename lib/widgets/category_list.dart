import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pseudofiles/classes/categories.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/classes/enums/media_enum.dart';
import 'package:pseudofiles/pages/apps/apps_page.dart';
import 'package:pseudofiles/pages/audio_page.dart';
import 'package:pseudofiles/pages/pictures/picture_page.dart';
import 'package:pseudofiles/pages/storage_page.dart';
import 'package:pseudofiles/pages/videos/videos_page.dart';
import 'package:pseudofiles/utils/constants.dart';
import 'package:pseudofiles/utils/themes.dart';

class CategoryList extends StatelessWidget {
  CategoryList({Key? key, required this.manager}) : super(key: key);
  final FileManager manager;

  final List<Category> categories = [];

  void setCategories() {
    categories.addAll([
      Category(
        'download',
        FontAwesomeIcons.fileDownload,
        StoragePage(manager: manager),
        manager.getDirectorySize,
        'storage/emulated/0/download',
      ),
      Category(
        'documents',
        FontAwesomeIcons.folderPlus,
        StoragePage(manager: manager),
        manager.getDirectorySize,
        'storage/emulated/0/documents',
      ),
      Category(
        'apps',
        FontAwesomeIcons.android,
        AppsPage(manager: manager),
        manager.getInstalledAppSizes,
        '',
      ),
      Category(
        'audio',
        Icons.photo_album,
        AudioPage(manager: manager),
        manager.getMediaSize,
        MediaType.audio,
      ),
      Category(
        'pictures',
        Icons.photo_album,
        PicturesPage(manager: manager),
        manager.getMediaSize,
        MediaType.image,
      ),
      Category(
        'video',
        FontAwesomeIcons.video,
        VideosPage(manager: manager),
        manager.getMediaSize,
        MediaType.video,
      ),
    ]);
  }

  Future<String> getDetails(Category category) async {
    //List<Directory> rootDirs = await manager.getRootDirectories();
    dynamic result = category.argument == ''
        ? await category.getSize()
        : await category.getSize(category.argument);
    category.size = result is int ? manager.getSize(result) : result;
    return category.size;
  }

  @override
  Widget build(BuildContext context) {
    setCategories();
    return SizedBox(
      height: size.height * 0.23,
      child: ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(20.0),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return categoryTile(index, context);
        },
      ),
    );
  }

  Widget categoryTile(index, context) => Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 2.0,
          vertical: 10.0,
        ),
        width: size.width * 0.3,
        child: InkWell(
          onTap: () {
            //manager.getInstalledAppSizes();
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => categories[index].page,
                ));
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: size.width * 0.06,
                backgroundColor: accentColor.withOpacity(0.4),
                child: Icon(
                  categories[index].icon,
                  size: size.width * 0.06,
                  color: accentColor,
                ),
              ),
              const SizedBox(height: 20.0),
              Text(
                categories[index].name.replaceFirst(
                    categories[index].name.substring(0, 1),
                    categories[index].name.substring(0, 1).toUpperCase()),
                style: TextStyle(
                  fontSize: size.width * 0.035,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5.0),
              FutureBuilder(
                future: getDetails(categories[index]),
                builder: (context, snapshot) => Text(
                  categories[index].size,
                  style: TextStyle(
                    fontSize: size.width * 0.025,
                  ),
                ),
              )
            ],
          ),
        ),
      );
}
