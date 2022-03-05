import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/ui/pages/archive_page.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../utils/constants.dart';

class AppDetails extends StatefulWidget {
  const AppDetails({Key? key, required this.map}) : super(key: key);
  final Map map;

  @override
  State<AppDetails> createState() => _AppDetailsState();
}

class _AppDetailsState extends State<AppDetails> {
  String apkPath = '';

  Widget listTitle(String title) => ListTile(
        contentPadding: EdgeInsets.zero,
        dense: true,
        title: Text(
          title.substring(0, 1).toUpperCase() + title.substring(1) + ":",
          style: TextStyle(
            fontSize: size.width * 0.04,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Details'),
        actions: [
          IconButton(
            onPressed: () {
              FileManager.launchSystemInfo(widget.map['packageName']);
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: size.width * 0.15,
                  width: size.width * 0.15,
                  child: Image.memory(widget.map['icon']),
                ),
                const SizedBox(width: 20.0),
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyText1,
                    children: <TextSpan>[
                      TextSpan(
                        text: widget.map['label'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: size.width * 0.05,
                        ),
                      ),
                      TextSpan(
                        text: '\n${widget.map['packageName']}\n',
                        style: TextStyle(
                          fontSize: size.width * 0.03,
                        ),
                      ),
                      TextSpan(text: 'Version: ${widget.map['version']}'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Padding(
              padding: EdgeInsets.only(left: size.width * 0.16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.launch),
                    iconSize: size.width * 0.05,
                    onPressed: () {
                      FileManager.launchApp(widget.map['packageName']);
                    },
                  ),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.googlePlay),
                    iconSize: size.width * 0.043,
                    onPressed: () async {
                      String url =
                          "https://play.google.com/store/apps/details?id=${widget.map['packageName']}";
                      if (await canLaunch(url)) {
                        launch(url);
                      }
                    },
                  ),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.archive),
                    iconSize: size.width * 0.043,
                    onPressed: () async {
                      String rootDir =
                          (await FileManager.getRootDirectories())[0].path;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArchivePage(
                            path: rootDir,
                            archivePath: apkPath,
                            isApk: true,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            //const SizedBox(height: 20.0),
            FutureBuilder(
              future: FileManager.getPackageDetails(widget.map['packageName']),
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  Map appDetailsMap = snapshot.data as Map;
                  TextStyle deatilsStyle = TextStyle(
                    fontSize: size.width * 0.03,
                  );
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(appDetailsMap.keys.length, (index) {
                      if (appDetailsMap.keys.elementAt(index) ==
                          "Basic Details") {
                        Map basicDetailsMap = appDetailsMap['Basic Details'];
                        basicDetailsMap.addAll(widget.map);
                        basicDetailsMap.removeWhere(
                          (key, value) =>
                              key == "icon" ||
                              key == "label" ||
                              key == "version" ||
                              key == "packageName",
                        );
                        apkPath = basicDetailsMap['source Directory'];
                        List keys = basicDetailsMap.keys.toList();
                        keys.sort((a, b) => a.length.compareTo(b.length));
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List<Widget>.generate(
                            keys.length + 1,
                            (index) => index == 0
                                ? listTitle('Basic Details')
                                : Text(
                                    '${keys[index - 1].substring(0, 1).toUpperCase()}'
                                            '${keys[index - 1].substring(1)}: ' +
                                        (keys[index - 1].contains('Date')
                                            ? FileManager.getDate(DateTime
                                                .fromMillisecondsSinceEpoch(
                                                basicDetailsMap[
                                                    keys[index - 1]],
                                              ))
                                            : '${basicDetailsMap[keys[index - 1]]}'),
                                  ),
                          ),
                        );
                      }
                      String label = appDetailsMap.keys.elementAt(index);
                      List list = appDetailsMap[label];
                      if (list.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          listTitle(label),
                          RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodyText1,
                              children: List.generate(
                                list.length,
                                (index) => TextSpan(
                                  style: deatilsStyle,
                                  text: '${list[index]}\n',
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
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
  }
}
