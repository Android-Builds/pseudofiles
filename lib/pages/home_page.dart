import 'package:flutter/material.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/pages/recent_files_page.dart';
import 'package:pseudofiles/pages/settings/settings_home.dart';
import 'package:pseudofiles/utils/constants.dart';
import 'package:pseudofiles/widgets/category_list.dart';
import 'package:pseudofiles/widgets/recent_files.dart';
import 'package:pseudofiles/widgets/storage_details.dart';
import 'package:pseudofiles/widgets/storage_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FileManager manager = FileManager();

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Files'),
        actions: [
          IconButton(
              onPressed: () {
                manager.getRecentFiles(10);
              },
              // onPressed: () => Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => SettingsHome(),
              //     )),
              icon: const Icon(Icons.settings))
        ],
      ),
      body: ListView(
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
