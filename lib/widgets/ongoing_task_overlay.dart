import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pseudofiles/classes/enums/operation_enum.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/utils/constants.dart';
import 'package:pseudofiles/utils/themes.dart';

class OngoingTaskOverlay extends StatelessWidget {
  const OngoingTaskOverlay({Key? key}) : super(key: key);

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
              '${(FileManager.operationType.name.replaceFirst(FileManager.operationType.name.substring(0, 1), FileManager.operationType.name.substring(0, 1).toUpperCase())).substring(0, FileManager.operationType.name.length - 1)}ing ${FileManager.taskEntityCount()}'),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: size.width * 0.9,
                child: LinearProgressIndicator(
                  color: FileManager.useMaterial3
                      ? Theme.of(context).colorScheme.secondary
                      : accentColor,
                  backgroundColor: (FileManager.useMaterial3
                          ? Theme.of(context).colorScheme.secondary
                          : accentColor)
                      .withOpacity(0.4),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Source: ${FileManager.selectedFiles.value.first.parent.path}',
                style: textStyle,
              ),
              FileManager.operationType != OperationType.delete
                  ? Text(
                      'Destination: ${FileManager.currentPath.value}',
                      style: textStyle,
                    )
                  : const SizedBox.shrink(),
              ValueListenableBuilder(
                  valueListenable: FileManager.taskFile,
                  builder: (context, value, child) => Text(
                        '${FileManager.operationType != OperationType.delete ? 'File' : 'Current'}: $value',
                        style: textStyle,
                      )),
              ValueListenableBuilder(
                  valueListenable: FileManager.speed,
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
