import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pseudofiles/classes/enums/operation_enum.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/utils/constants.dart';
import 'package:pseudofiles/utils/themes.dart';

class OngoingTaskOverlay extends StatelessWidget {
  const OngoingTaskOverlay({Key? key, required this.manager}) : super(key: key);
  final FileManager manager;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(fontSize: size.width * 0.032);
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 5.0,
        sigmaY: 5.0,
      ),
      child: SizedBox(
        height: size.height * 0.35,
        width: size.width,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          contentPadding: const EdgeInsets.all(20.0),
          insetPadding: const EdgeInsets.all(30.0),
          title: Text(
              '${(manager.operationType.name.replaceFirst(manager.operationType.name.substring(0, 1), manager.operationType.name.substring(0, 1).toUpperCase())).substring(0, manager.operationType.name.length - 1)}ing ${manager.taskEntityCount()}'),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: size.width * 0.9,
                child: LinearProgressIndicator(
                  color: accentColor,
                  backgroundColor: accentColor.withOpacity(0.4),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Source: ${manager.selectedFiles.value.first.parent.path}',
                style: textStyle,
              ),
              manager.operationType != OperationType.delete
                  ? Text(
                      'Destination: ${manager.currentPath.value}',
                      style: textStyle,
                    )
                  : const SizedBox.shrink(),
              ValueListenableBuilder(
                  valueListenable: manager.taskFile,
                  builder: (context, value, child) => Text(
                        '${manager.operationType != OperationType.delete ? 'File' : 'Current'}: $value',
                        style: textStyle,
                      )),
              ValueListenableBuilder(
                  valueListenable: manager.speed,
                  builder: (context, value, child) => Text(
                        'Speed: $value',
                        style: textStyle,
                      )),
            ],
          ),
        ),
      ),
    );
  }
}
