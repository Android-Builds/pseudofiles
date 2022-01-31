import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pseudofiles/classes/media_enum.dart';

enum sortTypes { name, date, size, type }

class FileManager {
  static bool _showHidden = false;
  static final ValueNotifier<String> _currentPath = ValueNotifier<String>('');
  final ValueNotifier<List<FileSystemEntity>> _selectedFiles =
      ValueNotifier<List<FileSystemEntity>>([]);
  final platform = const MethodChannel('pseudoFiles');
  static ScrollController _dashBoardScrollController = ScrollController();
  static ScrollController _storagePageScrollController = ScrollController();

  bool get showHidden => _showHidden;

  set showHidden(bool value) => _showHidden = value;

  ValueNotifier<String> get currentPath => _currentPath;
  ValueNotifier<List<FileSystemEntity>> get selectedFiles => _selectedFiles;

  static getDashBoardScrollController() {
    return _dashBoardScrollController;
  }

  static getStoragePageScrollController() {
    return _storagePageScrollController;
  }

  void reloadPath() {
    if (_currentPath.value.endsWith(Platform.pathSeparator)) {
      _currentPath.value =
          _currentPath.value.substring(0, _currentPath.value.length - 1);
    } else {
      _currentPath.value =
          _currentPath.value.substring(0, _currentPath.value.length) +
              Platform.pathSeparator;
    }
  }

  Future<String> getRootDirectory() async {
    List<Directory> rootDirs = await getRootDirectories();
    if (_currentPath.value.contains('0')) {
      return rootDirs[0].path;
    } else {
      return rootDirs[1].path;
    }
  }

  String? getMimeType(String fileName) {
    String? ext = lookupMimeType(fileName);
    return ext != null
        ? (ext.split('/')[0] == 'application'
            ? ext.split('/')[1]
            : ext.split('/')[0])
        : ext;
  }

  String getDate(DateTime dateTime) {
    return DateFormat.yMMMEd().add_jm().format(dateTime);
  }

  static String getFileName(FileSystemEntity entity) {
    return entity.path.split(Platform.pathSeparator).last;
  }

  static FileStat getFileStat(FileSystemEntity file) {
    return file.statSync();
  }

  //File System Entity operations
  void createDirectory(String name) {
    Directory(_currentPath.value + Platform.pathSeparator + name).createSync();
  }

  void deleteEntity() {
    for (var element in _selectedFiles.value) {
      try {
        element.deleteSync();
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    _selectedFiles.value = List.from(_selectedFiles.value)..clear();
  }

  void createFile(String name) {
    File(_currentPath.value + Platform.pathSeparator + name).createSync();
  }

  bool copyToDirectory(File file) {
    File copiedFile = file.copySync(
        currentPath.value + Platform.pathSeparator + getFileName(file));
    return copiedFile.existsSync();
  }

  void listFiles() {
    List<FileSystemEntity> files = [];
    for (var element in selectedFiles.value) {
      if (element is Directory) {
        files.addAll(element.listSync(followLinks: true, recursive: true));
      } else {
        files.add(element);
      }
    }
  }

  void copyEntities() {}

  //
  bool isFile(FileSystemEntity entity) {
    return entity is File;
  }

  bool shouldGetHiddenFiles(FileSystemEntity entity) {
    if (_showHidden) {
      return true;
    } else {
      return getFileName(entity).startsWith('.') && !_showHidden;
    }
  }

  String getEntityCount(int count) {
    switch (count) {
      case 0:
        return 'Empty';
      case 1:
        return '$count file';
      default:
        return '$count files';
    }
  }

  getSize(int bytes) {
    const suffix = ['B', 'KB', 'MB', 'GB', 'TB'];
    int bytes2 = bytes;
    if (bytes != 0) {
      int base = 0;
      while (bytes > 1024) {
        bytes = bytes ~/ 1024;
        base++;
      }
      return '${(bytes2 / pow(1024, base)).toStringAsFixed(2)} ${suffix[base]}';
    } else {
      return '0B';
    }
  }

  //Methods to move between directories

  Future<void> goToRootDirectory() async {
    changeDirectory((await getRootDirectory()));
  }

  Future<bool> isRootDirectory() async {
    return (await getRootDirectories()).any((element) {
      return _currentPath.value
          .split(Platform.pathSeparator)
          .toSet()
          .difference(element.path.split(Platform.pathSeparator).toSet())
          .isEmpty;
    });
  }

  void goToParentDirectory() async {
    if (!(await isRootDirectory())) {
      changeDirectory(Directory(_currentPath.value).parent.path);
    }
  }

  void changeDirectory(String path) {
    _currentPath.value = path;
  }

  //Methods for fetching FileSystemEntity list

  static int getComparisionByCase(sortTypes type, FileSystemEntity entity1,
      FileSystemEntity entity2, bool descending) {
    if (descending) {
      FileSystemEntity temp = entity2;
      entity2 = entity1;
      entity1 = temp;
    }
    switch (type) {
      case sortTypes.name:
        return getFileName(entity1)
            .toLowerCase()
            .compareTo(getFileName(entity2).toLowerCase());
      case sortTypes.date:
        return getFileStat(entity1)
            .modified
            .compareTo(getFileStat(entity2).modified);
      case sortTypes.size:
        return getFileStat(entity1).size.compareTo(getFileStat(entity2).size);
      case sortTypes.type:
        return entity1.runtimeType
            .toString()
            .compareTo(entity1.runtimeType.toString());
    }
  }

  static List<FileSystemEntity> getSortedList(List<FileSystemEntity> files,
      List<FileSystemEntity> folders, sortTypes type) {
    files.sort((a, b) => getComparisionByCase(type, a, b, false));
    folders.sort((a, b) => getComparisionByCase(type, a, b, false));
    return [...folders, ...files];
  }

  Future<List<Directory>> getRootDirectories() async {
    List<Directory> storages = (await getExternalStorageDirectories())!;
    storages =
        storages.map((e) => Directory(e.path.split('Android')[0])).toList();
    return storages;
  }

  static fetchAllDirectories(List<Object> arguments) async {
    List<FileSystemEntity> directories =
        Directory(arguments[1] as String).listSync();
    final List<FileSystemEntity> files =
        directories.whereType<File>().toList().where((element) {
      if (_showHidden) {
        return true;
      } else {
        return !getFileName(element).startsWith('.');
      }
    }).toList();
    final List<FileSystemEntity> folders =
        directories.whereType<Directory>().toList().where((element) {
      if (_showHidden) {
        return true;
      } else {
        return !getFileName(element).startsWith('.');
      }
    }).toList();
    (arguments[0] as SendPort)
        .send(getSortedList(files, folders, sortTypes.name));
  }

  Future<dynamic> spawnNewIsolate() async {
    ReceivePort receivePort = ReceivePort();
    dynamic result;
    if (_currentPath.value.isEmpty) {
      List<Directory> rootDirectories = await getRootDirectories();
      // directories = rootDirectories[0].listSync();
      _currentPath.value = rootDirectories[0].path;
    } else {
      // directories = Directory(_currentPath.value).listSync();
    }
    try {
      await Future.wait([
        Isolate.spawn(fetchAllDirectories, [
          receivePort.sendPort,
          _currentPath.value
        ]).then((_) => receivePort.first, onError: (_) => receivePort.close()),
      ]).then((value) {
        result = value.first;
      });
      receivePort.close();
      return result;
    } catch (e) {
      debugPrint("Error: $e");
      return result;
    }
  }

  Future<List<FileSystemEntity>> getDirectories(sortTypes type) async {
    List<FileSystemEntity> directories = [];
    if (_currentPath.value.isEmpty) {
      List<Directory> rootDirectories = await getRootDirectories();
      directories = rootDirectories[0].listSync();
      _currentPath.value = rootDirectories[0].path;
    } else {
      directories = Directory(_currentPath.value).listSync();
    }
    final List<FileSystemEntity> files =
        directories.whereType<File>().toList().where((element) {
      if (_showHidden) {
        return true;
      } else {
        return !getFileName(element).startsWith('.');
      }
    }).toList();
    final List<FileSystemEntity> folders =
        directories.whereType<Directory>().toList().where((element) {
      if (_showHidden) {
        return true;
      } else {
        return !getFileName(element).startsWith('.');
      }
    }).toList();
    return getSortedList(files, folders, type);
  }

  List<FileSystemEntity> getAllFiles(String path) {
    return Directory(path).listSync();
  }

  //Platform Channel Calls
  Future<String> getDirectorySize(String path) async {
    try {
      final String result = await platform.invokeMethod(
        'getDirectorySize',
        {'path': path},
      );
      return result;
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
    return '';
  }

  Future<Map<dynamic, dynamic>> getStorageInfo() async {
    try {
      final Map<dynamic, dynamic>? storageMap =
          await platform.invokeMapMethod('getStorageInfo');
      return storageMap!;
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
    return {'': ''};
  }

  Future<dynamic> getAllMedias(MediaType type) async {
    try {
      final List result = await platform
          .invokeListMethod('getAllImages', {'mediaType': type.name}) as List;
      return result;
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
    return '';
  }

  Future<dynamic> getInstalledApps() async {
    try {
      final List result =
          await platform.invokeListMethod('getInstalledApps') as List;
      return result;
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
    return '';
  }

  Future<dynamic> getApkFromStorage() async {
    try {
      final dynamic result =
          await platform.invokeListMethod('getApkFromStorage');
      return result;
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
    return '';
  }

  Future<dynamic> getApkDetails(String path) async {
    try {
      final dynamic result =
          await platform.invokeMapMethod('getApkDetails', {'path': path});
      return result;
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
    return '';
  }

  Future<dynamic> getMediaSize(MediaType type) async {
    try {
      final dynamic result =
          await platform.invokeMethod('getMediaSize', {'mediaType': type.name});
      return result;
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
    return '';
  }

  Future<dynamic> getInstalledAppSizes() async {
    try {
      final dynamic result =
          await platform.invokeMethod('getInstalledAppSizes');
      return result;
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
    return '';
  }

  Future<dynamic> getRecentFiles(int limit) async {
    try {
      final dynamic result =
          await platform.invokeMethod('getRecentFiles', {'limit': limit});
      return result;
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
    return '';
  }
}
