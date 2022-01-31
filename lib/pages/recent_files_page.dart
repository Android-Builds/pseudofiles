import 'package:flutter/material.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/widgets/recent_files.dart';

class RecentFilesPage extends StatelessWidget {
  const RecentFilesPage({Key? key, required this.manager}) : super(key: key);
  final FileManager manager;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recent Files'),
      ),
      body: RecentFiles(
        manager: manager,
        count: -1,
        scroll: true,
      ),
    );
  }
}
