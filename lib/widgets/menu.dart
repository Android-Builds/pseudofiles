import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/utils/constants.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key, required this.manager}) : super(key: key);
  final FileManager manager;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  WhyFarther _selection = WhyFarther.harder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.manager.selectedFiles,
      builder: (context, value, child) {
        List<FileSystemEntity> list = value as List<FileSystemEntity>;
        return list.isEmpty ? unSelected() : selected();
      },
    );
  }

  Widget selected() {
    return PopupMenuButton<WhyFarther>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      onSelected: (WhyFarther result) {
        setState(() {
          _selection = result;
        });
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<WhyFarther>>[
        PopupMenuItem<WhyFarther>(
          value: WhyFarther.harder,
          child: StatefulBuilder(
            builder: (context, setState) {
              return CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Show hidden files',
                  style: TextStyle(fontSize: size.width * 0.035),
                ),
                value: widget.manager.showHidden,
                onChanged: (value) {
                  setState(() => widget.manager.showHidden = value!);
                  widget.manager.reloadPath();
                  Navigator.pop(context);
                  // BlocProvider.of<GetfilesBloc>(context)
                  //     .add(GetAllFiles(rootDir));
                },
              );
            },
          ),
        ),
        PopupMenuItem<WhyFarther>(
          value: WhyFarther.smarter,
          child: Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.sort_by_alpha),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.file_copy),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.format_size),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.calendar_today),
              ),
            ],
          ),
        ),
        const PopupMenuItem<WhyFarther>(
          value: WhyFarther.selfStarter,
          child: Text('Being a self-starter'),
        ),
        const PopupMenuItem<WhyFarther>(
          value: WhyFarther.tradingCharter,
          child: Text('Placed'),
        ),
      ],
    );
  }

  Widget unSelected() {
    return PopupMenuButton<WhyFarther>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      onSelected: (WhyFarther result) {
        setState(() {
          _selection = result;
        });
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<WhyFarther>>[
        PopupMenuItem<WhyFarther>(
          value: WhyFarther.harder,
          child: StatefulBuilder(
            builder: (context, setState) {
              return CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Show hidden files',
                  style: TextStyle(fontSize: size.width * 0.035),
                ),
                value: widget.manager.showHidden,
                onChanged: (value) {
                  setState(() => widget.manager.showHidden = value!);
                  widget.manager.reloadPath();
                  Navigator.pop(context);
                  // BlocProvider.of<GetfilesBloc>(context)
                  //     .add(GetAllFiles(rootDir));
                },
              );
            },
          ),
        ),
        PopupMenuItem<WhyFarther>(
          value: WhyFarther.smarter,
          child: Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.sort_by_alpha),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.file_copy),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.format_size),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.calendar_today),
              ),
            ],
          ),
        ),
        const PopupMenuItem<WhyFarther>(
          value: WhyFarther.selfStarter,
          child: Text('Being a self-starter'),
        ),
        const PopupMenuItem<WhyFarther>(
          value: WhyFarther.tradingCharter,
          child: Text('Placed'),
        ),
      ],
    );
  }
}

enum WhyFarther { harder, smarter, selfStarter, tradingCharter }
