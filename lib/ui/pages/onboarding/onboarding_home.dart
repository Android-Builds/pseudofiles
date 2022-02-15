import 'package:flutter/material.dart';
import 'package:pseudofiles/ui/pages/onboarding/onboarding_page1.dart';
import 'package:pseudofiles/ui/pages/onboarding/onboarding_page2.dart';
import 'package:pseudofiles/ui/pages/onboarding/onboarding_page3.dart';
import 'package:pseudofiles/ui/pages/onboarding/onboarding_page4.dart';
import 'package:pseudofiles/utils/constants.dart';

class OnboardingHome extends StatefulWidget {
  const OnboardingHome({Key? key}) : super(key: key);

  @override
  State<OnboardingHome> createState() => _OnboardingHomeState();
}

class _OnboardingHomeState extends State<OnboardingHome>
    with TickerProviderStateMixin {
  late TabController onboradingTabController;
  PageController onboardingPageController = PageController();

  @override
  void initState() {
    onboradingTabController = TabController(
      initialIndex: 0,
      length: 4,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Stack(
        children: [
          PageView(
            controller: onboardingPageController,
            onPageChanged: (value) {
              setState(() {
                onboradingTabController.index = value;
              });
            },
            children: [
              OnboardingPage1(
                onboardingPageController: onboardingPageController,
              ),
              OnboardingPage2(
                onboardingPageController: onboardingPageController,
              ),
              OnboardingPage3(
                onboardingPageController: onboardingPageController,
              ),
              OnboardingPage4(
                onboardingPageController: onboardingPageController,
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TabPageSelector(
                indicatorSize: size.width * 0.02,
                controller: onboradingTabController,
              ),
            ),
          ),
        ],
      )),
    );
  }
}
