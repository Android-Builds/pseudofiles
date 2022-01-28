import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pseudofiles/utils/constants.dart';

part 'getfiles_event.dart';
part 'getfiles_state.dart';

class GetfilesBloc extends Bloc<GetfilesEvent, GetfilesState> {
  GetfilesBloc() : super(GetfilesInitial()) {
    on<GetAllFiles>((event, emit) async {
      emit(GetfilesFetching());
      List<FileSystemEntity> files = await getFiles(event.directory);
      String path = '';
      if (event.directory.isEmpty) {
        List<String> paths = files[0].path.split(Platform.pathSeparator);
        path = paths.sublist(0, paths.length - 1).join(Platform.pathSeparator) +
            Platform.pathSeparator;
      } else {
        path = event.directory;
      }

      emit(GetfilesFetched(files, path));
    });
  }
}

Future<List<FileSystemEntity>> getFiles(String directory) async {
  if (directory.isEmpty) {
    Directory? storage = await getExternalStorageDirectory();
    directory = storage!.path
            .split(Platform.pathSeparator)
            .sublist(0, 4)
            .join(Platform.pathSeparator) +
        Platform.pathSeparator;
    rootDir = directory;
  }
  List<FileSystemEntity> allFiles = Directory(directory).listSync();
  List<FileSystemEntity> files = [];
  List<FileSystemEntity> folders = [];
  for (var element in allFiles) {
    if (element is Directory &&
        element.path.split(Platform.pathSeparator).last.contains('.')) {
    } else {
      if (element is File) {
        files.add(element);
      } else {
        folders.add(element);
      }
    }
  }
  folders.sort((a, b) => a.path
      .split(Platform.pathSeparator)
      .last
      .compareTo(b.path.split(Platform.pathSeparator).last));
  files.sort((a, b) => a.path
      .split(Platform.pathSeparator)
      .last
      .compareTo(b.path.split(Platform.pathSeparator).last));
  folders.addAll(files);
  return folders;
}
