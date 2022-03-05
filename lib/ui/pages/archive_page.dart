import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pseudofiles/classes/file_manager.dart';

import '../../bloc/getFiles_bloc/getfiles_bloc.dart';
import '../../utils/constants.dart';
import '../../utils/themes.dart';
import '../widgets/persistant_header.dart';

class ArchivePage extends StatefulWidget {
  const ArchivePage({
    Key? key,
    required this.path,
    required this.archivePath,
    this.isApk = false,
  }) : super(key: key);
  final String path;
  final String archivePath;
  final bool isApk;

  @override
  _ArchivePageState createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  String dirPath = '';
  Map rootDir = {};
  late Archive archive;
  ValueNotifier<Map> browseMap = ValueNotifier<Map>({});
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    dirPath =
        widget.isApk ? widget.path : Directory(widget.archivePath).parent.path;
    BlocProvider.of<GetfilesBloc>(context).add(const GetAllFiles());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void listFiles(String path) {
    Map filesMap = {};
    path.split('/').forEach((element) {
      if (path.split('/').indexOf(element) == 0) {
        filesMap = rootDir;
      }
      if (!filesMap.containsKey(element)) {
        if (path.split('/').last != element) {
          filesMap.addAll({element: {}});
          filesMap = filesMap[element];
        } else {
          filesMap.addAll({element: ''});
        }
      } else if (filesMap[element] != '') {
        filesMap = filesMap[element];
      }
    });
  }

  Future getFiles(Map map) async {
    if (map.isNotEmpty) {
      return map;
    }
    /*
    Moved from reading the archive as byte array to reading as input buffer as either: 
    1. dart couldn't hold such long byte array or 
    2. ZipDecoder().decodebytes() couldn't decode a long byte array
    */
    RegExp fileExtExp = RegExp(r'([a-zA-Z0-9])*\.+([a-zA-Z0-9])*');
    final inputStream = InputFileStream(widget.archivePath);
    archive = ZipDecoder().decodeBuffer(inputStream);
    for (ArchiveFile file in archive) {
      if (file.isFile ||
          (fileExtExp.hasMatch(file.name) && !file.name.endsWith('/'))) {
        listFiles(file.name);
      }
    }
    return rootDir;
  }

  Future<String> getFilesAndFoldersCount(Map map) async {
    if (map.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 1));
    }
    int folders = (map.isEmpty ? rootDir : map)
        .keys
        .where((element) => rootDir[element] != '')
        .length;
    int files = (map.isEmpty ? rootDir : map).keys.length - folders;
    return '$folders folders, $files files';
  }

  List<String> getDirectoryNames(String key) {
    List<String> splitPath = archive.files
        .where((element) => element.name.contains(key))
        .first
        .name
        .split(key)
        .first
        .split('/')
      ..removeWhere((element) => element == '')
      ..insert(0, widget.archivePath.split('/').last);
    return splitPath;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (browseMap.value
                .isNotEmpty && //the archive has just been opened and none of it's directories have been visited
            browseMap.value.keys.length != rootDir.keys.length) {
          //the current files map is same as the archive file map
          Map filesMap = rootDir;
          List<String> paths = archive.files
              .where((element) =>
                  element.name.contains(browseMap.value.keys.first))
              .first
              .name
              .split('/');
          paths = paths.sublist(
              0,
              paths.indexWhere(
                      (element) => element == browseMap.value.keys.first) -
                  1);
          for (String path in paths) {
            filesMap = filesMap[path];
          }
          browseMap.value = filesMap;
          return false;
        }
        return true;
      },
      child: ValueListenableBuilder(
          valueListenable: browseMap,
          builder: (context, value, child) {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Column(
                  children: [
                    const Text('Archive'),
                    FutureBuilder(
                      future: getFilesAndFoldersCount(value as Map),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            snapshot.data as String,
                            style: TextStyle(fontSize: size.width * 0.025),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.archive),
                    onPressed: showExtractDialog,
                  ),
                ],
              ),
              body: FutureBuilder(
                future: getFiles(browseMap.value),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Map archiveMap = snapshot.data as Map;
                    return CustomScrollView(
                      slivers: [
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: PersistentHeader(
                            height: size.height * 0.06,
                            widget: Container(
                              width: size.width,
                              color: Theme.of(context).scaffoldBackgroundColor,
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                controller: scrollController,
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    getDirectoryNames(archiveMap.keys.first)
                                        .length,
                                itemBuilder: (context, index) {
                                  List<String> dirNames =
                                      getDirectoryNames(archiveMap.keys.first);
                                  if (index == dirNames.length - 1) {
                                    Future.delayed(
                                        const Duration(milliseconds: 100), () {
                                      scrollController.animateTo(
                                          scrollController
                                              .position.maxScrollExtent,
                                          duration:
                                              const Duration(milliseconds: 200),
                                          curve: Curves.bounceInOut);
                                    });
                                  }
                                  return Row(
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          if (dirNames[index] ==
                                              widget.archivePath
                                                  .split('/')
                                                  .last) {
                                            browseMap.value = rootDir;
                                          } else {
                                            Map filesMap = rootDir;
                                            List<String> paths = archive.files
                                                .where((element) => element.name
                                                    .contains(dirNames[index]))
                                                .first
                                                .name
                                                .split('/');
                                            paths = paths.sublist(
                                                0,
                                                paths.indexWhere((element) =>
                                                        element ==
                                                        dirNames[index]) +
                                                    1);
                                            for (String path in paths) {
                                              filesMap = filesMap[path];
                                            }
                                            browseMap.value = filesMap;
                                          }
                                          BlocProvider.of<GetfilesBloc>(context)
                                              .add(const GetAllFiles());
                                        },
                                        child: Text(
                                          dirNames[index],
                                          style: TextStyle(
                                            color: dirNames[index] ==
                                                    FileManager.getCurrentDir()
                                                ? FileManager.useMaterial3
                                                    ? null
                                                    : accentColor
                                                : Theme.of(context)
                                                    .textTheme
                                                    .bodyText1!
                                                    .color,
                                            fontSize: size.width * 0.04,
                                          ),
                                        ),
                                      ),
                                      index == dirNames.length - 1
                                          ? const SizedBox.shrink()
                                          : const Icon(Icons.arrow_right),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return ListTile(
                                onTap: () async {
                                  if (archiveMap.values.elementAt(index) !=
                                      '') {
                                    browseMap.value =
                                        archiveMap.values.elementAt(index);
                                  } else {
                                    try {
                                      Directory tempDir =
                                          await getTemporaryDirectory();
                                      String fileName = FileManager.joinPaths(
                                        tempDir.path,
                                        archiveMap.keys.elementAt(index),
                                      );
                                      ArchiveFile file = archive.files
                                          .where((element) => element.name
                                              .contains(archiveMap.keys
                                                  .elementAt(index)))
                                          .first;
                                      final List<int> data =
                                          file.content as List<int>;
                                      File(fileName)
                                        ..createSync(recursive: true)
                                        ..writeAsBytesSync(data);
                                      OpenFile.open(fileName);
                                    } catch (e) {
                                      debugPrint(e.toString());
                                      showErrorDailogue();
                                    }
                                  }
                                },
                                leading: CircleAvatar(
                                  radius: size.width * 0.06,
                                  backgroundColor: FileManager.useMaterial3
                                      ? Theme.of(context).colorScheme.primary
                                      : accentColor,
                                  foregroundColor: FileManager.useMaterial3
                                      ? Theme.of(context).colorScheme.background
                                      : Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color,
                                  child: FaIcon(
                                      archiveMap.values.elementAt(index) != ''
                                          ? FontAwesomeIcons.solidFolder
                                          : FontAwesomeIcons.solidFile),
                                ),
                                title: Text(archiveMap.keys.elementAt(index)),
                                subtitle: Text(
                                  archiveMap.values.elementAt(index) != ''
                                      ? archiveMap.values
                                              .elementAt(index)
                                              .keys
                                              .length
                                              .toString() +
                                          ' items'
                                      : FileManager.getSize(archive.files
                                          .where((element) => element.name
                                              .contains(archiveMap.keys
                                                  .elementAt(index)))
                                          .first
                                          .size),
                                  style:
                                      TextStyle(fontSize: size.width * 0.025),
                                ),
                              );
                            },
                            childCount: archiveMap.length,
                          ),
                        ),
                      ],
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            );
          }),
    );
  }

  showErrorDailogue() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        title: const Text('Error opening Archive'),
        actionsAlignment: MainAxisAlignment.center,
        content: const Text(
          'File is either damaged or password protected',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Ok'),
          )
        ],
      ),
    );
  }

  showExtractDialog() {
    showDialog(
        context: context,
        builder: (context) {
          dirPath = widget.isApk
              ? widget.path
              : Directory(widget.archivePath).parent.path;
          return AlertDialog(
              contentPadding: const EdgeInsets.all(10.0),
              actionsPadding: EdgeInsets.zero,
              title: const Text('Select Directory'),
              content: SingleChildScrollView(
                child: StatefulBuilder(builder: (context, setState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 13.0),
                        child: Text(
                          dirPath,
                          style: TextStyle(fontSize: size.width * 0.03),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      FutureBuilder(
                          future: FileManager.getDirectories(path: dirPath),
                          builder: (_, snapshot) {
                            if (snapshot.hasData) {
                              List<FileSystemEntity> list =
                                  snapshot.data as List<FileSystemEntity>;
                              return ListBody(
                                children:
                                    List.generate(list.length + 1, (index) {
                                  if (index == 0) {
                                    return ListTile(
                                      onTap: () async {
                                        if (!await FileManager.isRootDirectory(
                                            path: dirPath)) {
                                          setState(() => dirPath =
                                              Directory(dirPath).parent.path);
                                        }
                                      },
                                      leading: const Icon(Icons.folder),
                                      title: const Text('...'),
                                    );
                                  }
                                  if (list[index - 1] is Directory) {
                                    return ListTile(
                                      onTap: () => setState(
                                          () => dirPath = list[index - 1].path),
                                      leading: const Icon(Icons.folder),
                                      title: Text(FileManager.getFileName(
                                          list[index - 1])),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                }),
                              );
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }),
                    ],
                  );
                }),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                    child: const Text('Select'),
                    onPressed: () {
                      /*
                      final inputStream = InputFileStream(widget.archivePath);
                      final Archive archive =
                          ZipDecoder().decodeBuffer(inputStream);
                      String newDir = FileManager.joinPaths(dirPath,
                          FileManager.getFileName(File(widget.archivePath)));
                      Directory(newDir).createSync();
                      extractArchiveToDisk(archive, newDir);
                      */
                      final bytes = File(widget.archivePath).readAsBytesSync();
                      Archive archive = ZipDecoder().decodeBytes(bytes);
                      String newDir = FileManager.joinPaths(dirPath,
                          FileManager.getFileName(File(widget.archivePath)));
                      bool failed = false;
                      for (ArchiveFile file in archive) {
                        final fileName = file.name;
                        RegExp fileExtExp =
                            RegExp(r'([a-zA-Z0-9])*\.+([a-zA-Z0-9])*');
                        if (file.isFile ||
                            (fileExtExp.hasMatch(fileName) &&
                                !file.name.endsWith('/'))) {
                          try {
                            final List<int> data = file.content as List<int>;
                            File(FileManager.joinPaths(newDir, fileName))
                              ..createSync(recursive: true)
                              ..writeAsBytesSync(data);
                          } catch (e) {
                            debugPrint(e.toString());
                            failed = true;
                            break;
                          }
                          if (failed) {
                            showErrorDailogue();
                          }
                        } else {
                          Directory(FileManager.joinPaths(newDir, fileName))
                              .create(recursive: true);
                        }
                      }
                      Navigator.pop(context);
                    })
              ]);
        });
  }
}
