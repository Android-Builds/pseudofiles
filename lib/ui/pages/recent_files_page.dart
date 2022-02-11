import 'package:flutter/material.dart';

import '../widgets/recent_files.dart';

class RecentFilesPage extends StatelessWidget {
  const RecentFilesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recent Files'),
      ),
      body: const RecentFiles(
        count: -1,
        scroll: true,
      ),
    );
  }
}
