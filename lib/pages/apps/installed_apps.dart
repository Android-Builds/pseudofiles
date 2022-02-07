import 'package:flutter/material.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/utils/constants.dart';

class InstalledApps extends StatefulWidget {
  const InstalledApps({Key? key, required this.manager}) : super(key: key);
  final FileManager manager;

  @override
  State<InstalledApps> createState() => _InstalledAppsState();
}

class _InstalledAppsState extends State<InstalledApps> {
  List<dynamic> allApps = [];

  Future<dynamic> getApps() async {
    await Future.delayed(const Duration(seconds: 2), () async {});
    if (allApps.isEmpty) {
      allApps = await widget.manager.getInstalledApps();
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
                contentPadding: const EdgeInsets.all(5.0),
                leading: CircleAvatar(
                  radius: size.width * 0.06,
                  backgroundImage: MemoryImage(map['icon']),
                ),
                title: Text(map['label']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(map['packageName'], style: subtytleStyle),
                    Text('Version: ${map['version']}', style: subtytleStyle),
                  ],
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
}
