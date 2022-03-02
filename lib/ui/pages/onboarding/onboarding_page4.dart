import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/ui/pages/home_page.dart';
import 'package:pseudofiles/utils/themes.dart';

class OnboardingPage4 extends StatefulWidget {
  const OnboardingPage4({
    Key? key,
    required this.onboardingPageController,
  }) : super(key: key);
  final PageController onboardingPageController;

  @override
  State<OnboardingPage4> createState() => _OnboardingPage4State();
}

class _OnboardingPage4State extends State<OnboardingPage4> {
  static bool storage = false;
  static bool usage = false;
  static bool terms = false;

  Future<bool> getSoragePermission() async {
    Permission permission = Permission.manageExternalStorage;
    PermissionStatus status = await permission.status;
    if (status.isDenied) {
      status = await permission.request();
    }
    return status == PermissionStatus.granted;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const ListTile(
            dense: true,
            title: Text(
              'Permissions',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          CheckboxListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            tileColor: Theme.of(context).backgroundColor,
            title: Row(
              children: const [
                Icon(Icons.folder),
                SizedBox(width: 20.0),
                Text(
                  'Storage',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            onChanged: (bool? value) async {
              storage = await getSoragePermission();
              setState(() {});
            },
            value: storage,
          ),
          const SizedBox(height: 10.0),
          CheckboxListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            tileColor: Theme.of(context).backgroundColor,
            title: Row(
              children: const [
                Icon(Icons.data_usage),
                SizedBox(width: 20.0),
                Text(
                  'Usage',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            onChanged: (bool? value) async {
              usage = await FileManager.grantUsagePermission();
              setState(() {});
            },
            value: usage,
          ),
          const SizedBox(height: 20.0),
          const ListTile(
            dense: true,
            title: Text(
              'Terms',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          TextField(
            enabled: false,
            decoration: InputDecoration(
              hintMaxLines: 12,
              hintText:
                  'By agreeing to this, I declare that I am aware that Peseudofiles is an unfinished product and is currently in the beta stage. Using this software can incure loss of my data and that I am solely responsible for my loss own data. I will not withheld anyone but myself responsible for the loss the the data. The developers of the software will not be responsible for whatever you might do with your data.',
              fillColor: Theme.of(context).backgroundColor,
              filled: true,
            ),
          ),
          const SizedBox(height: 10.0),
          CheckboxListTile(
              value: terms,
              title: const Text(
                'I agree to the terms and conditions mentioned above',
              ),
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (value) {
                setState(() {
                  terms = value!;
                });
              }),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                  heroTag: 'move to home',
                  backgroundColor: FileManager.useMaterial3
                      ? Theme.of(context).colorScheme.primary
                      : accentColor,
                  child: const Icon(MaterialIcons.keyboard_arrow_right),
                  onPressed: () {
                    if (storage && usage && terms) {
                      //TODO: Hive called here
                      final prefBox = Hive.box('prefs');
                      prefBox.put('firstLaunch', false);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text(
                            'Allow all permissions and accept the terms to proceed'),
                      ));
                    }
                  }),
            ],
          )
        ],
      ),
    );
  }
}
