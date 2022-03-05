import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/ui/pages/apps/app_details.dart';
import 'package:pseudofiles/utils/constants.dart';
import 'package:share_plus/share_plus.dart';

class InstalledApps extends StatefulWidget {
  const InstalledApps({Key? key}) : super(key: key);

  @override
  State<InstalledApps> createState() => _InstalledAppsState();
}

class _InstalledAppsState extends State<InstalledApps> {
  static List<dynamic> allApps = [];

  Future<dynamic> getApps() async {
    if (allApps.isEmpty) {
      allApps = await FileManager.getInstalledApps();
    }
    return allApps;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getApps(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List apps = snapshot.data as List;
          return ListView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: apps.length,
            itemBuilder: (context, index) {
              Map map = apps[index];
              TextStyle subtytleStyle = TextStyle(
                fontSize: size.width * 0.025,
                color: Colors.grey,
              );
              return ListTile(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AppDetails(map: map),
                    )),
                contentPadding: const EdgeInsets.all(5.0),
                leading: SizedBox(
                  height: size.width * 0.12,
                  width: size.width * 0.12,
                  child: Image.memory(map['icon']),
                ),
                title: Text(map['label']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(map['packageName'], style: subtytleStyle),
                    Text('Version: ${map['version']}', style: subtytleStyle),
                  ],
                ),
                trailing: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    child: const Icon(Icons.more_vert),
                    onTapDown: (TapDownDetails details) {
                      RenderBox overlay = Overlay.of(context)!
                          .context
                          .findRenderObject() as RenderBox;
                      showMenu(
                        context: context,
                        position: RelativeRect.fromRect(
                          details.globalPosition & const Size(40, 40),
                          Offset.zero & overlay.size,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        items: [
                          PopupMenuItem(
                            child: const Text('Backup'),
                            onTap: () async {
                              String rootDir =
                                  (await FileManager.getRootDirectories())[0]
                                      .path;
                              Directory backupDir = Directory(
                                  FileManager.joinPaths(
                                      rootDir, 'pseudofiles/backups'));
                              if (!backupDir.existsSync()) {
                                backupDir.createSync(recursive: true);
                              }
                              File apkFile = File(map['source Directory']);
                              if (!File(FileManager.joinPaths(
                                      backupDir.path, '${map['label']}.apk'))
                                  .existsSync()) {
                                apkFile.copySync(FileManager.joinPaths(
                                    backupDir.path, '${map['label']}.apk'));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    content: Text('Backed Up Successfully'),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    content: Text('Backup already exists'),
                                  ),
                                );
                              }
                            },
                          ),
                          PopupMenuItem(
                              child: const Text('Share'),
                              onTap: () =>
                                  Share.shareFiles([map['source Directory']])),
                          PopupMenuItem(
                            child: const Text('Uninstall'),
                            onTap: () =>
                                FileManager.uninstallApp(map['packageName']),
                          ),
                          PopupMenuItem(
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Properties'),
                              onTap: () {
                                showProperties(map);
                              },
                            ),
                            onTap: null,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              );
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  showProperties(map) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: Text(map['label']),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  SizedBox(
                    height: size.width * 0.15,
                    width: size.width * 0.15,
                    child: Image.memory(map['icon']),
                  ),
                  const SizedBox(height: 20.0),
                  propertyText('Package: ${map['packageName']}'),
                  propertyText('Version: ${map['version']}'),
                  FutureBuilder(
                    future: FileManager.getPackageDetails(map['packageName']),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Map detailsMap =
                            (snapshot.data as Map)['Basic Details'];
                        File file = File(map['source Directory']);
                        FileStat stat = file.statSync();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            propertyText(
                              'UID: ${detailsMap['UID']}',
                            ),
                            propertyText(
                              'Size: ${stat.size}',
                            ),
                            propertyText(
                              'Target SDK: ${detailsMap['Target Sdk Version']}',
                            ),
                            propertyText(
                              'Installed Date: ${FileManager.getDate(DateTime.fromMillisecondsSinceEpoch(map['installed Date']))}',
                            ),
                            propertyText(
                              'Modified Date: ${FileManager.getDate(DateTime.fromMillisecondsSinceEpoch(map['modified Date']))}',
                            ),
                            propertyText(
                              'Data Directory: ${detailsMap['Data Directory']}',
                            ),
                          ],
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget propertyText(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: size.width * 0.033),
    );
  }
}
