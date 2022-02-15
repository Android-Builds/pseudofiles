import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pseudofiles/utils/themes.dart';

import '../../../utils/constants.dart';

class OnboardingPage3 extends StatelessWidget {
  const OnboardingPage3({
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
            'assets/permission.svg',
            height: size.height * 0.2,
            width: size.height * 0.2,
          ),
          const SizedBox(height: 50.0),
          Text(
            'Permissions !',
            style: TextStyle(
              fontSize: size.width * 0.06,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10.0),
          const Text(
            'We\'ll need some permissions\nin order to work properly',
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  onboardingPageController.animateToPage(3,
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
