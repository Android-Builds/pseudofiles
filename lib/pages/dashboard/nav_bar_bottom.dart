import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/utils/constants.dart';

class NavBarBottom extends StatefulWidget {
  const NavBarBottom({
    Key? key,
    required this.pageController,
  }) : super(key: key);
  final PageController pageController;

  @override
  _NavBarBottomState createState() => _NavBarBottomState();
}

class _NavBarBottomState extends State<NavBarBottom> {
  bool showNavBar = true;
  static int selectedIndex = 0;

  void listener(ScrollController scrollController) {}

  void addListerner(ScrollController scrollController) {
    scrollController.addListener(() {
      if (!mounted) {
        return;
      }
      if (scrollController.offset - scrollController.initialScrollOffset >
          100.0) {
        setState(() => showNavBar = false);
      } else {
        setState(() => showNavBar = true);
      }
    });
  }

  @override
  void initState() {
    addListerner(FileManager.getDashBoardScrollController());
    addListerner(FileManager.getStoragePageScrollController());
    super.initState();
  }

  void goToPage(int page) {
    widget.pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 200),
      curve: Curves.bounceInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 200),
      firstChild: Container(
        height: size.height * 0.08,
        width: size.width * 0.3,
        margin: const EdgeInsets.all(20.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: FittedBox(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              navBarIcon(FontAwesomeIcons.home, 0),
              navBarIcon(FontAwesomeIcons.list, 1),
            ],
          ),
        ),
      ),
      secondChild: const SizedBox.shrink(),
      crossFadeState:
          showNavBar ? CrossFadeState.showFirst : CrossFadeState.showSecond,
    );
  }

  Widget navBarIcon(IconData icon, int index) => Container(
        decoration: BoxDecoration(
          color:
              index == selectedIndex ? Colors.red.shade200 : Colors.transparent,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: IconButton(
          onPressed: () {
            setState(() {
              selectedIndex = index;
            });
            goToPage(selectedIndex);
          },
          icon: Icon(
            icon,
            size: size.width * 0.05,
          ),
        ),
      );
}
