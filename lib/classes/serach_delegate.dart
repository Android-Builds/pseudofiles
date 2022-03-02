import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:open_file/open_file.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/ui/widgets/file_list_tile.dart';

import '../utils/constants.dart';

class FileSearch extends SearchDelegate<String> {
  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme;
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        Hive.box('searchSuggestions').put('suggestions', suggestions.join(","));
        close(context, '');
      },
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isNotEmpty && !suggestions.contains(query)) {
      suggestions.add(query);
    }
    return filesList();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return query.isNotEmpty
        ? filesList()
        : ListView.builder(
            itemBuilder: (context, index) {
              if (index == 0) {
                return ListTile(
                  dense: true,
                  title: const Text(
                    'Suggestions',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: TextButton(
                    child: const Text('Clear'),
                    onPressed: () {
                      suggestions.clear();
                      Hive.box('searchSuggestions').clear();
                      close(context, '');
                    },
                  ),
                );
              } else {
                return ListTile(
                  leading: const Icon(Icons.restore),
                  onTap: () {
                    query = suggestions[index - 1];
                  },
                  title: Text(suggestions[index - 1]),
                );
              }
            },
            itemCount: suggestions.length + 1,
          );
  }

  Widget filesList() {
    return FutureBuilder(
      future: FileManager.getSearchedFiles(query),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<String> fileList = snapshot.data as List<String>;
          return ListView.builder(
            itemCount: fileList.length + 1,
            itemBuilder: (_, index) {
              if (index == 0) {
                return ListTile(
                  dense: true,
                  title: Text(
                    '${fileList.length} items',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              } else {
                File file = File(fileList[index - 1]);
                return FileListTile(
                  entity: file,
                  oneTapAction: (entity) {
                    OpenFile.open(file.path);
                  },
                  longPressAction: (entity) {},
                );
              }
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
