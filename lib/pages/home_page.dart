import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/pages/storage_page/storage_page.dart';
import 'package:pseudofiles/utils/constants.dart';
import 'package:pseudofiles/pages/dashboard/dashboard.dart';
import 'package:pseudofiles/widgets/action_buttons_bar.dart';

import 'dashboard/nav_bar_bottom.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController pageController = PageController();
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      extendBody: true,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: [
          DashBoard(pageController: pageController),
          const StoragePage(),
        ],
      ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: FileManager.selectedFiles,
        builder: (context, value, child) {
          List<FileSystemEntity> list = value as List<FileSystemEntity>;
          return list.isEmpty
              ? NavBarBottom(pageController: pageController)
              : const ActionButtonsBar();
        },
      ),
    );
  }
}
