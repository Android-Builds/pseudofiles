import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/widgets/file_list_tile.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({Key? key}) : super(key: key);

  @override
  _DocumentsPageState createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  static List<String> allDocuments = [];
  ScrollController scrollController = ScrollController();

  Future<List<String>> getAllDocs() async {
    if (allDocuments.isEmpty) {
      allDocuments = (await FileManager.getAllDocuments());
    }
    return allDocuments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Documents'),
      ),
      body: FutureBuilder(
        future: getAllDocs(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            List<String> allDocs = snapshot.data as List<String>;
            return Scrollbar(
              controller: scrollController,
              isAlwaysShown: true,
              child: ListView.builder(
                itemCount: allDocs.length,
                controller: scrollController,
                itemBuilder: (context, index) {
                  File file = File(allDocs[index]);
                  return FileListTile(
                      entity: file,
                      oneTapAction: (entity) {
                        OpenFile.open(file.path);
                      },
                      longPressAction: (entity) {});
                },
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
