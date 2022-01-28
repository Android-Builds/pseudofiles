import 'package:flutter/material.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/pages/files_page.dart';
import 'package:pseudofiles/utils/constants.dart';
import 'package:pseudofiles/utils/themes.dart';
import 'package:pseudofiles/widgets/app_bar.dart';

class StoragePage extends StatefulWidget {
  const StoragePage({Key? key, required this.manager}) : super(key: key);
  final FileManager manager;

  @override
  State<StoragePage> createState() => _StoragePageState();
}

class _StoragePageState extends State<StoragePage> {
  @override
  void initState() {
    getPermissions();
    super.initState();
  }

  TextEditingController controller = TextEditingController();

  UnderlineInputBorder borderStyle =
      UnderlineInputBorder(borderSide: BorderSide(color: accentColor));

  Future<void> _createFileOrFolderDialog(String type) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create a $type'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Input a name to create a $type'),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: borderStyle,
                    focusedBorder: borderStyle,
                    enabledBorder: borderStyle,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                controller.clear();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                if (type == 'file') {
                  widget.manager.createFile(controller.text);
                } else {
                  widget.manager.createDirectory(controller.text);
                }
                controller.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  getPermissions() async {
    Permission permission = Permission.manageExternalStorage;
    var status = await permission.status;
    if (status.isDenied) {
      status = await permission.request();
    }
    //if (await Permission.location.isRestricted) {}
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(manager: widget.manager),
      body: HawkFabMenu(
        icon: AnimatedIcons.menu_close,
        fabColor: accentColor,
        items: [
          HawkFabMenuItem(
            label: 'New File',
            ontap: () {
              _createFileOrFolderDialog('file');
              setState(() {});
            },
            icon: const Icon(Icons.file_copy),
            color: accentColor,
          ),
          HawkFabMenuItem(
            label: 'New Folder',
            ontap: () {
              _createFileOrFolderDialog('folder');
              setState(() {});
            },
            icon: const Icon(Icons.folder_open),
            color: accentColor,
          ),
        ],
        body: FilesPage(manager: widget.manager),
      ),
    );
  }
}
