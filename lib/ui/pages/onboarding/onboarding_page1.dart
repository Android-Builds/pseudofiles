import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pseudofiles/utils/themes.dart';

import '../../../utils/constants.dart';

class OnboardingPage1 extends StatelessWidget {
  const OnboardingPage1({
    Key? key,
    required this.onboardingPageController,
  }) : super(key: key);
  final PageController onboardingPageController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          SvgPicture.asset(
            'assets/pic1.svg',
            // color: accentColor,
            // colorBlendMode: BlendMode.modulate,
            height: size.height * 0.2,
            width: size.height * 0.2,
          ),
          const SizedBox(height: 50.0),
          Text(
            'Welcome to Pseudo Files',
            style: TextStyle(
              fontSize: size.width * 0.06,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  onboardingPageController.animateToPage(1,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.bounceInOut);
                },
                child: const Text('Next'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
