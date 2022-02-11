import 'package:flutter/material.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/utils/constants.dart';

import '../../widgets/category_list.dart';
import '../../widgets/recent_files.dart';
import '../../widgets/storage_details.dart';
import '../recent_files_page.dart';
import '../settings/settings_home.dart';

class DashBoard extends StatelessWidget {
  const DashBoard({Key? key, required this.pageController}) : super(key: key);

  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Files'),
        actions: [
          IconButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsHome(),
                  )),
              icon: const Icon(Icons.settings))
        ],
      ),
      body: Scrollbar(
        controller: FileManager.getDashBoardScrollController(),
        child: ListView(
          controller: FileManager.getDashBoardScrollController(),
          children: [
            const StorageDetails(),
            const ListTile(
              dense: true,
              title: Text(
                'Categories',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            CategoryList(pageController: pageController),
            ListTile(
              dense: true,
              title: const Text(
                'Recent Files',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: TextButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RecentFilesPage(),
                    )),
                child: Text(
                  'See More',
                  style: TextStyle(fontSize: size.width * 0.03),
                ),
              ),
            ),
            const RecentFiles(count: 10),
            //StorageList(manager: manager),
          ],
        ),
      ),
    );
  }
}
