import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/utils/constants.dart';
import 'package:pseudofiles/utils/themes.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key, required this.manager}) : super(key: key);
  final FileManager manager;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.manager.selectedFiles,
      builder: (context, value, child) {
        List<FileSystemEntity> list = value as List<FileSystemEntity>;
        return selected();
      },
    );
  }

  Widget selected() {
    return PopupMenuButton(
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
                    setState(() =>
                        widget.manager.descending = !widget.manager.descending);
                    await Future.delayed(const Duration(milliseconds: 200));
                    Navigator.pop(context);
                    widget.manager.reloadPath();
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
                            value: widget.manager.descending,
                            onChanged: null,
                          )
                        ],
                      )),
                ))),
        menuItem(StatefulBuilder(
            builder: (context, setState) => InkWell(
                  onTap: () async {
                    setState(() =>
                        widget.manager.showHidden = !widget.manager.showHidden);
                    await Future.delayed(const Duration(milliseconds: 200));
                    Navigator.pop(context);
                    widget.manager.reloadPath();
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
                            value: widget.manager.showHidden,
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
          groupValue: widget.manager.sortType,
          onChanged: (sortTypes? value) {
            setState(() => widget.manager.sortType = value!);
            Navigator.pop(context);
            widget.manager.reloadPath();
          },
        ),
      );
}
