import 'package:flutter/material.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/widgets/apks_list.dart';
import 'package:pseudofiles/widgets/app_bar.dart';
import 'package:pseudofiles/widgets/installed_apps.dart';

final List<String> _tabs = ['Installed', 'APKs'];

class AppsPage extends StatelessWidget {
  const AppsPage({Key? key, required this.manager}) : super(key: key);

  final FileManager manager;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Apps'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Align(
                alignment: Alignment.centerLeft,
                child: TabBar(
                    indicatorSize: TabBarIndicatorSize.label,
                    isScrollable: true,
                    tabs: _tabs.map((String key) => Tab(text: key)).toList())),
          ),
        ),
        body: TabBarView(children: [
          InstalledApps(manager: manager),
          ApksList(manager: manager),
        ]),
      ),
    );
  }
}
