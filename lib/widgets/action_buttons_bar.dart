import 'package:flutter/material.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/utils/constants.dart';

class ActionButtonsBar extends StatefulWidget {
  const ActionButtonsBar({Key? key, required this.manager}) : super(key: key);
  final FileManager manager;

  @override
  _ActionButtonsBarState createState() => _ActionButtonsBarState();
}

class _ActionButtonsBarState extends State<ActionButtonsBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.08,
      width: size.width * 0.8,
      margin: const EdgeInsets.all(20.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: FittedBox(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            navBarIcon(Icons.copy),
            navBarIcon(Icons.cut),
            navBarIcon(Icons.delete),
            widget.manager.selectedFiles.value.length == 1
                ? navBarIcon(Icons.edit)
                : const SizedBox.shrink(),
            navBarIcon(Icons.share),
            navBarIcon(Icons.select_all),
            navBarIcon(Icons.more_vert),
          ],
        ),
      ),
    );
  }

  Widget navBarIcon(IconData icon) => IconButton(
        onPressed: () {},
        icon: Icon(
          icon,
          size: size.width * 0.05,
        ),
      );
}
