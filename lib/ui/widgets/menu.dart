import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pseudofiles/classes/enums/sort_types.dart';
import 'package:pseudofiles/classes/file_manager.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: FileManager.selectedFiles,
      builder: (context, value, child) {
        List<FileSystemEntity> list = value as List<FileSystemEntity>;
        return selected(list.isEmpty);
      },
    );
  }

  Widget selected(bool isEnabled) {
    return PopupMenuButton(
      enabled: isEnabled,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        menuItem(InkWell(
          onTap: () {},
          splashColor: Colors.transparent,
          child: const ListTile(
            dense: true,
            leading: Icon(Icons.sort),
            title: Text(
              'Sort Type:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        )),
        sortTypeMenu(sortTypes.name),
        sortTypeMenu(sortTypes.date),
        sortTypeMenu(sortTypes.size),
        sortTypeMenu(sortTypes.type),
        menuItem(StatefulBuilder(
            builder: (context, setState) => InkWell(
                  onTap: () async {
                    setState(
                        () => FileManager.descending = !FileManager.descending);
                    await Future.delayed(const Duration(milliseconds: 200));
                    Navigator.pop(context);
                    FileManager.reloadPath();
                  },
                  child: Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Row(
                        children: [
                          const Text('Descending'),
                          const Spacer(),
                          Checkbox(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            value: FileManager.descending,
                            onChanged: null,
                          )
                        ],
                      )),
                ))),
        menuItem(StatefulBuilder(
            builder: (context, setState) => InkWell(
                  onTap: () async {
                    setState(
                        () => FileManager.showHidden = !FileManager.showHidden);
                    await Future.delayed(const Duration(milliseconds: 200));
                    Navigator.pop(context);
                    FileManager.reloadPath();
                  },
                  child: Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Row(
                        children: [
                          const Text('Show Hidden'),
                          const Spacer(),
                          Checkbox(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            value: FileManager.showHidden,
                            onChanged: null,
                          )
                        ],
                      )),
                ))),
      ],
    );
  }

  PopupMenuItem menuItem(Widget child, [Function()? onTap]) => PopupMenuItem(
        padding: EdgeInsets.zero,
        child: child,
        onTap: onTap,
      );

  PopupMenuItem sortTypeMenu(sortTypes type) => menuItem(
        RadioListTile(
          value: type,
          title: Text('${type.name[0].toUpperCase()}${type.name.substring(1)}'),
          groupValue: FileManager.sortType,
          onChanged: (sortTypes? value) {
            setState(() => FileManager.sortType = value!);
            Navigator.pop(context);
            FileManager.reloadPath();
          },
        ),
      );
}
