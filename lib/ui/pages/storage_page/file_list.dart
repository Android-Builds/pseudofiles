import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:pseudofiles/bloc/getFiles_bloc/getfiles_bloc.dart';
import 'package:pseudofiles/utils/constants.dart';

class FileList extends StatelessWidget {
  const FileList({
    Key? key,
    required this.files,
    required this.path,
  }) : super(key: key);

  final List<FileSystemEntity> files;
  final String path;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          Widget w = snapshot.data as Widget;
          return w;
        }
      },
    );
  }

  Future<Widget> getList() async {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: files.length + 1,
      itemBuilder: (context, index) {
        //List<FileSystemEntity> fileStat = Directory(files[index - 1].path).listSync();
        if (index == 0) {
          return ListTile(
            onTap: () {
              BlocProvider.of<GetfilesBloc>(context).add(const GetAllFiles());
            },
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              foregroundColor: Theme.of(context).textTheme.bodyText1!.color,
              radius: 23.0,
              child: const Icon(Icons.folder),
            ),
            title: const Text('...'),
          );
        } else {
          FileStat fileStat = files[index - 1].statSync();
          return ListTile(
            onTap: () {
              if (files[index - 1] is Directory) {
                BlocProvider.of<GetfilesBloc>(context).add(const GetAllFiles());
              }
            },
            leading: files[index - 1] is File &&
                    getMimeType(files[index - 1].path) == 'image'
                ? CircleAvatar(
                    radius: 23.0,
                    backgroundColor: Colors.blue,
                    foregroundColor:
                        Theme.of(context).textTheme.bodyText1!.color,
                    backgroundImage: FileImage(
                      File(files[index - 1].path),
                    ),
                  )
                : CircleAvatar(
                    radius: 23.0,
                    backgroundColor: Colors.blue,
                    backgroundImage: FileImage(File(files[index - 1].path)),
                    foregroundColor:
                        Theme.of(context).textTheme.bodyText1!.color,
                    child: Icon(files[index - 1] is File
                        ? Icons.file_present
                        : Icons.folder),
                  ),
            title:
                Text(files[index - 1].path.split(Platform.pathSeparator).last),
            subtitle: Row(
              children: [
                Text(
                  '${((fileStat.size) / (1024 * 1024)).toStringAsFixed(2)} mb',
                  style: TextStyle(fontSize: size.width * 0.025),
                ),
                const Spacer(),
                Text(
                  getDate(fileStat.modified),
                  style: TextStyle(fontSize: size.width * 0.025),
                )
              ],
            ),
          );
        }
      },
    );
  }

  getMimeType(String fileName) {
    String? ext = lookupMimeType(fileName);
    return ext != null ? ext.split('/')[0] : ext;
  }

  getDate(DateTime dateTime) {
    return DateFormat.yMMMEd().add_jm().format(dateTime);
  }
}
