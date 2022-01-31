import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/pages/storage_page.dart';
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
  FileManager manager = FileManager();
  PageController pageController = PageController();
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: pageController,
            children: [
              DashBoard(manager: manager),
              StoragePage(manager: manager),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            // child: NavBarBottom(
            //   pageController: pageController,
            // ),
            // child: ActionButtonsBar(),
            child: ValueListenableBuilder(
              valueListenable: manager.selectedFiles,
              builder: (context, value, child) {
                List<FileSystemEntity> list = value as List<FileSystemEntity>;
                return list.isEmpty
                    ? NavBarBottom(pageController: pageController)
                    : ActionButtonsBar(manager: manager);
                // return AnimatedCrossFade(
                //   duration: const Duration(milliseconds: 100),
                //   firstChild: NavBarBottom(
                //     pageController: pageController,
                //   ),
                //   secondChild: const ActionButtonsBar(),
                //   crossFadeState: list.isEmpty
                //       ? CrossFadeState.showFirst
                //       : CrossFadeState.showSecond,
                // );
              },
            ),
          )
        ],
      ),
    );
  }
}
