import 'package:flutter/material.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/pages/recent_files_page.dart';
import 'package:pseudofiles/pages/settings/settings_home.dart';
import 'package:pseudofiles/utils/constants.dart';
import 'package:pseudofiles/widgets/storage_details.dart';

import '../../widgets/category_list.dart';
import '../../widgets/recent_files.dart';

class DashBoard extends StatelessWidget {
  const DashBoard({Key? key, required this.manager}) : super(key: key);

  final FileManager manager;

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
                    builder: (context) => SettingsHome(),
                  )),
              icon: const Icon(Icons.settings))
        ],
      ),
      body: ListView(
        controller: FileManager.getDashBoardScrollController(),
        children: [
          StorageDetails(manager: manager),
          const ListTile(
            dense: true,
            title: Text(
              'Categories',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          CategoryList(manager: manager),
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
                    builder: (context) => RecentFilesPage(manager: manager),
                  )),
              child: Text(
                'See More',
                style: TextStyle(fontSize: size.width * 0.03),
              ),
            ),
          ),
          RecentFiles(manager: manager, count: 10),
          //StorageList(manager: manager),
        ],
      ),
    );
  }
}
