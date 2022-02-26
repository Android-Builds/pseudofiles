import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/ui/pages/storage_page/flie_system_list.dart';

import '../../bloc/getFiles_bloc/getfiles_bloc.dart';
import '../../utils/constants.dart';

class ArchivePage extends StatefulWidget {
  const ArchivePage({
    Key? key,
    required this.path,
    required this.archivePath,
  }) : super(key: key);
  final String path;
  final String archivePath;

  @override
  _ArchivePageState createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  String dirPath = '';

  @override
  void initState() {
    dirPath = Directory(widget.archivePath).parent.path;
    BlocProvider.of<GetfilesBloc>(context).add(const GetAllFiles());
    super.initState();
  }

  @override
  void dispose() {
    FileManager.goToRootDirectory();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text('Archive'),
            FutureBuilder(
              future: FileManager.getFilesAndFolderCount(),
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
      body: BlocBuilder<GetfilesBloc, GetfilesState>(
        builder: (context, state) {
          if (state is GetfilesFetched) {
            return FileSystemEntityList(
              list: state.files,
              isArchivePage: true,
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  showExtractDialog() {
    showDialog(
        context: context,
        builder: (context) {
          dirPath = Directory(widget.archivePath).parent.path;
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
                              children: List.generate(list.length + 1, (index) {
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
                  final inputStream = InputFileStream(widget.archivePath);
                  final Archive archive =
                      ZipDecoder().decodeBuffer(inputStream);
                  String newDir = FileManager.joinPaths(dirPath,
                      FileManager.getFileName(File(widget.archivePath)));
                  Directory(newDir).createSync();
                  extractArchiveToDisk(archive, newDir);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
