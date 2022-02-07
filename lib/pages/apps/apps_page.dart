import 'package:flutter/material.dart';
import 'package:pseudofiles/pages/apps/apks_list.dart';
import 'package:pseudofiles/pages/apps/installed_apps.dart';

final List<String> _tabs = ['Installed', 'APKs'];

class AppsPage extends StatelessWidget {
  const AppsPage({Key? key}) : super(key: key);

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
        body: const TabBarView(children: [
          InstalledApps(),
          ApksList(),
        ]),
      ),
    );
  }
}
