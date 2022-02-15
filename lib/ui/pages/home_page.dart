import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/utils/constants.dart';

import '../../bloc/theme_bloc/theme_bloc.dart';
import '../widgets/action_buttons_bar.dart';
import 'dashboard/dashboard.dart';
import 'dashboard/nav_bar_bottom.dart';
import 'storage_page/storage_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController homeTabController;
  final snackBarDuration = const Duration(seconds: 2);
  static DateTime popUpTime =
      DateTime.now().subtract(const Duration(seconds: 5));

  @override
  void initState() {
    homeTabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    super.initState();
  }

  Future<bool> onWillPop() async {
    if (FileManager.pageController.page == 0) {
      final now = DateTime.now();
      if (now.difference(popUpTime) < snackBarDuration) {
        return true;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Press one more time to exit'),
          duration: snackBarDuration,
          elevation: 5.0,
          behavior: SnackBarBehavior.floating,
          onVisible: () {
            popUpTime = DateTime.now();
          },
        ),
      );
    } else {
      if (!(await FileManager.isRootDirectory())) {
        FileManager.goToParentDirectory();
      } else {
        FileManager.pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.bounceInOut,
        );
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: onWillPop,
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          if (state is CompactnessChanged) {
            FileManager.useCompactUi = state.useCompactUi;
          } else if (state is BottomNavbarHidden) {
            FileManager.keepNavbarHidden = state.hideBottomNavbar;
          }
          Widget body = PageView(
            onPageChanged: (value) {
              homeTabController.index = value;
            },
            physics: FileManager.keepNavbarHidden
                ? const AlwaysScrollableScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            controller: FileManager.pageController,
            children: const [
              DashBoard(),
              StoragePage(),
            ],
          );
          return Scaffold(
              extendBody: true,
              body: FileManager.keepNavbarHidden
                  ? Stack(
                      children: [
                        body,
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TabPageSelector(
                              indicatorSize: size.width * 0.02,
                              controller: homeTabController,
                            ),
                          ),
                        ),
                      ],
                    )
                  : body,
              bottomNavigationBar: ValueListenableBuilder(
                valueListenable: FileManager.selectedFiles,
                builder: (context, value, child) {
                  List<FileSystemEntity> list = value as List<FileSystemEntity>;
                  return list.isEmpty
                      ? (FileManager.useCompactUi ||
                              FileManager.keepNavbarHidden
                          ? const SizedBox.shrink()
                          : const NavBarBottom())
                      : const ActionButtonsBar();
                },
              ));
        },
      ),
    );
  }
}
