import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pseudofiles/classes/categories.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/classes/enums/media_enum.dart';
import 'package:pseudofiles/pages/apps/apps_page.dart';
import 'package:pseudofiles/pages/audio_page.dart';
import 'package:pseudofiles/pages/pictures/picture_page.dart';
import 'package:pseudofiles/pages/storage_page/storage_page.dart';
import 'package:pseudofiles/pages/videos/videos_page.dart';
import 'package:pseudofiles/utils/constants.dart';
import 'package:pseudofiles/utils/themes.dart';

class CategoryList extends StatelessWidget {
  CategoryList({Key? key, required this.pageController}) : super(key: key);
  final PageController pageController;

  final List<Category> categories = [];

  void setCategories() {
    categories.addAll([
      Category(
        'download',
        FontAwesomeIcons.fileDownload,
        const StoragePage(),
        FileManager.getDirectorySize,
        'storage/emulated/0/download',
      ),
      Category(
        'documents',
        FontAwesomeIcons.folderPlus,
        const StoragePage(),
        FileManager.getDirectorySize,
        'storage/emulated/0/documents',
      ),
      Category(
        'apps',
        FontAwesomeIcons.android,
        const AppsPage(),
        FileManager.getInstalledAppSizes,
        '',
      ),
      Category(
        'audio',
        Icons.photo_album,
        const AudioPage(),
        FileManager.getMediaSize,
        MediaType.audio,
      ),
      Category(
        'pictures',
        Icons.photo_album,
        const PicturesPage(),
        FileManager.getMediaSize,
        MediaType.image,
      ),
      Category(
        'video',
        FontAwesomeIcons.video,
        const VideosPage(),
        FileManager.getMediaSize,
        MediaType.video,
      ),
    ]);
  }

  Future<String> getDetails(Category category) async {
    //List<Directory> rootDirs = await manager.getRootDirectories();
    dynamic result = category.argument == ''
        ? await category.getSize()
        : await category.getSize(category.argument);
    category.size = result is int ? FileManager.getSize(result) : result;
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
          onTap: () async {
            //manager.getInstalledAppSizes();
            if (index == 0 || index == 1) {
              FileManager.changeDirectory(FileManager.joinPaths(
                  (await FileManager.getRootDirectories())[0].path,
                  categories[index].name));
              pageController.animateToPage(
                1,
                duration: const Duration(milliseconds: 200),
                curve: Curves.bounceInOut,
              );
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => categories[index].page,
                  ));
            }
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
