import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/classes/media_enum.dart';
import 'package:pseudofiles/utils/constants.dart';
import 'package:pseudofiles/utils/themes.dart';
import 'package:pseudofiles/widgets/app_bar.dart';

class AudioPage extends StatefulWidget {
  const AudioPage({Key? key, required this.manager}) : super(key: key);
  final FileManager manager;

  @override
  _AudioPageState createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  List<dynamic> allSongs = [];

  Future<dynamic> getSongs() async {
    if (allSongs.isEmpty) {
      allSongs = await widget.manager.getAllMedias(MediaType.audio);
    }
    return allSongs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audios'),
      ),
      body: FutureBuilder(
        future: getSongs(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List dirList = snapshot.data as List;
            return ListView.builder(
              itemCount: dirList.length,
              itemBuilder: (context, index) {
                Map map = dirList[index];
                List audioList = map.values.elementAt(0);
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: audioList.length + 1,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    TextStyle subtitleStyle = TextStyle(
                      fontSize: size.width * 0.025,
                      color: Colors.grey,
                    );
                    if (index == 0) {
                      return ListTile(
                        title: Text(
                          map.keys.first.toString().replaceFirst(
                              map.keys.first.toString().substring(0, 1),
                              map.keys.first
                                  .toString()
                                  .substring(0, 1)
                                  .toUpperCase()),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    } else {
                      File file = File(audioList[index - 1]);
                      FileStat fileStat = file.statSync();
                      return ListTile(
                        leading: CircleAvatar(
                          radius: size.width * 0.06,
                          child: const Icon(Icons.music_note),
                          backgroundColor: accentColor,
                          foregroundColor:
                              Theme.of(context).textTheme.bodyText1!.color,
                        ),
                        title: Text(FileManager.getFileName(file)),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.manager.getSize(fileStat.size),
                              style: subtitleStyle,
                            ),
                            Text(
                              widget.manager.getDate(fileStat.modified),
                              style: subtitleStyle,
                            ),
                          ],
                        ),
                      );
                    }
                  },
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
