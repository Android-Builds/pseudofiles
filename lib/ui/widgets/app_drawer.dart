import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/utils/constants.dart';

import '../../utils/themes.dart';
import '../pages/settings/settings_home.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).backgroundColor,
      child: ListView(
        children: [
          const SizedBox(height: 10.0),
          Container(
            padding: const EdgeInsets.all(10.0),
            alignment: Alignment.bottomLeft,
            height: size.height * 0.3,
            child: Column(
              children: [
                const Spacer(),
                SvgPicture.asset(
                  'assets/icon.svg',
                  height: size.height * 0.15,
                  color: FileManager.useMaterial3
                      ? Theme.of(context).colorScheme.primary
                      : accentColor,
                ),
                const Spacer(),
                Row(
                  children: [
                    Text(
                      'Pseudo Files',
                      style: TextStyle(
                        fontSize: size.width * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsHome(),
                          )),
                      icon: const Icon(Icons.settings),
                    )
                  ],
                ),
              ],
            ),
          ),
          titleListTile('Storage'),
          storageListTile(
            Icons.sd_card_outlined,
            'Internal Storage',
            '${allStorageMap['storage1Free']} GB free of ${allStorageMap['storage1Total']} GB',
            () async {
              FileManager.changeDirectory(
                  (await FileManager.getRootDirectories()).first.path);
              await Future.delayed(const Duration(milliseconds: 200));
              Navigator.pop(context);
            },
          ),
          allStorageMap['storage2Total'] != 0.0
              ? storageListTile(
                  Icons.sd_card_outlined,
                  'SD Card',
                  '${allStorageMap['storage2Free']} GB free of ${allStorageMap['storage2Total']} GB',
                  () async {
                    FileManager.changeDirectory(
                        (await FileManager.getRootDirectories()).last.path);
                    await Future.delayed(const Duration(milliseconds: 200));
                    Navigator.pop(context);
                  },
                )
              : const SizedBox.shrink(),
          titleListTile('Collection'),
          ListView.builder(
            shrinkWrap: true,
            itemCount: categories.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) => ListTile(
              leading: Icon(categories[index].icon),
              title: Text(categories[index].name),
              onTap: () async {
                if (index == 0) {
                  FileManager.changeDirectory(FileManager.joinPaths(
                      (await FileManager.getRootDirectories())[0].path,
                      categories[index].name));
                  await Future.delayed(const Duration(milliseconds: 200));
                  Navigator.pop(context);
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => categories[index].page,
                      ));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget titleListTile(String text) => ListTile(
        dense: true,
        title: Row(
          children: [
            Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 20.0),
            const Expanded(child: Divider(thickness: 2.0)),
          ],
        ),
      );

  Widget storageListTile(
    IconData icon,
    String text,
    String storageText,
    Function() onTap,
  ) =>
      ListTile(
        minLeadingWidth: 10.0,
        leading: Icon(icon),
        onTap: onTap,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: size.width * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              storageText,
              style: TextStyle(
                fontSize: size.width * 0.03,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
}
