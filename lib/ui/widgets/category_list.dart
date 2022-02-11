import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pseudofiles/classes/categories.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/classes/enums/media_enum.dart';
import 'package:pseudofiles/utils/constants.dart';
import 'package:pseudofiles/utils/themes.dart';

import '../../bloc/theme_bloc/theme_bloc.dart';
import '../pages/apps/apps_page.dart';
import '../pages/audio_page.dart';
import '../pages/documents_page.dart';
import '../pages/pictures/picture_page.dart';
import '../pages/storage_page/storage_page.dart';
import '../pages/videos/videos_page.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({Key? key, required this.pageController})
      : super(key: key);
  final PageController pageController;

  void setCategories() {
    if (categories.isEmpty) {
      categories.addAll([
        Category(
          'Download',
          FontAwesomeIcons.fileDownload,
          const StoragePage(),
          FileManager.getDirectorySize,
          'storage/emulated/0/Download',
        ),
        Category(
          'Documents',
          FontAwesomeIcons.folderPlus,
          const DocumentsPage(),
          FileManager.getDocumentsSize,
          '',
        ),
        Category(
          'Apps',
          FontAwesomeIcons.android,
          const AppsPage(),
          FileManager.getInstalledAppSizes,
          '',
        ),
        Category(
          'Audio',
          FontAwesomeIcons.music,
          const AudioPage(),
          FileManager.getMediaSize,
          MediaType.audio,
        ),
        Category(
          'Pictures',
          FontAwesomeIcons.image,
          const PicturesPage(),
          FileManager.getMediaSize,
          MediaType.image,
        ),
        Category(
          'Video',
          FontAwesomeIcons.video,
          const VideosPage(),
          FileManager.getMediaSize,
          MediaType.video,
        ),
      ]);
    }
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
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return SizedBox(
          // height: size.height * 0.16,
          height: size.height * 0.3,
          child: GridView.builder(
            itemCount: categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.2,
            ),
            itemBuilder: (_, index) {
              return SizedBox(
                height: size.height * 0.1,
                width: size.width * 0.1,
                child: InkWell(
                  onTap: () async {
                    if (index == 0) {
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: size.width * 0.055,
                        backgroundColor: (FileManager.useMaterial3
                                ? Theme.of(context).colorScheme.secondary
                                : accentColor)
                            .withOpacity(0.4),
                        child: Icon(
                          categories[index].icon,
                          size: size.width * 0.05,
                          color: FileManager.useMaterial3
                              ? Theme.of(context).colorScheme.secondary
                              : accentColor,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        categories[index].name,
                        style: TextStyle(
                          fontSize: size.width * 0.03,
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
            },
          ),
          // child: ListView.builder(
          //   shrinkWrap: true,
          //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
          //   scrollDirection: Axis.horizontal,
          //   itemCount: categories.length,
          //   itemBuilder: (context, index) {
          //     return categoryTile(index, context);
          //   },
          // ),
        );
      },
    );
  }

  Widget categoryTile(index, context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 5.0,
          ),
          padding: const EdgeInsets.all(10.0),
          alignment: Alignment.centerLeft,
          width: size.width * 0.23,
          child: InkWell(
            onTap: () async {
              //manager.getInstalledAppSizes();
              if (index == 0) {
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
                  radius: size.width * 0.055,
                  backgroundColor: (FileManager.useMaterial3
                          ? Theme.of(context).colorScheme.secondary
                          : accentColor)
                      .withOpacity(0.4),
                  child: Icon(
                    categories[index].icon,
                    size: size.width * 0.05,
                    color: FileManager.useMaterial3
                        ? Theme.of(context).colorScheme.secondary
                        : accentColor,
                  ),
                ),
                const SizedBox(height: 20.0),
                Text(
                  categories[index].name,
                  style: TextStyle(
                    fontSize: size.width * 0.03,
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
        ),
      );
}
