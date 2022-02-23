import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pseudofiles/utils/constants.dart';
import 'package:pseudofiles/utils/themes.dart';

import '../../bloc/theme_bloc/theme_bloc.dart';
import '../../classes/file_manager.dart';

class StorageGraph extends StatefulWidget {
  const StorageGraph({
    Key? key,
    required this.storage,
    required this.index,
  }) : super(key: key);
  final int index;
  final String storage;

  @override
  State<StorageGraph> createState() => _StorageGraphState();
}

class _StorageGraphState extends State<StorageGraph> {
  final RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
  @override
  Widget build(BuildContext context) {
    final percentage = allStorageMap['storage${widget.index}Used'] /
        allStorageMap['storage${widget.index}Total'];
    return FileManager.useCompactUi
        ? compactGraph(percentage)
        : normalGraph(percentage);
  }

  Widget compactGraph(double percentage) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
      child: InkWell(
        onTap: () async {
          FileManager.changeDirectory(
              (await FileManager.getRootDirectories())[widget.index - 1].path);
          await Future.delayed(const Duration(milliseconds: 100));
          FileManager.pageController.animateToPage(1,
              duration: const Duration(milliseconds: 200),
              curve: Curves.bounceInOut);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  widget.storage,
                  style: TextStyle(
                    fontSize: size.width * 0.04,
                    fontWeight: FontWeight.bold,
                    textBaseline: TextBaseline.alphabetic,
                  ),
                ),
                Text(
                  ' • ' +
                      ((allStorageMap['storage${widget.index}Free'] /
                                  allStorageMap[
                                      'storage${widget.index}Total']) *
                              100)
                          .toStringAsFixed(2) +
                      '% free',
                  style: const TextStyle(
                    textBaseline: TextBaseline.alphabetic,
                  ),
                )
              ],
            ),
            const SizedBox(height: 10.0),
            LinearPercentIndicator(
              padding: EdgeInsets.zero,
              percent: percentage,
              lineHeight: 7.0,
              progressColor: FileManager.useMaterial3
                  ? Theme.of(context).colorScheme.primary
                  : accentColor,
              backgroundColor: (FileManager.useMaterial3
                      ? Theme.of(context).colorScheme.primary
                      : accentColor)
                  .withOpacity(0.3),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${allStorageMap['storage${widget.index}Used'].toStringAsPrecision(4).replaceAll(regex, '')} GB Used',
                ),
                Text(
                  '${allStorageMap['storage${widget.index}Total']} GB Total',
                ),
              ],
            ),
            const SizedBox(height: 16.0, child: Divider()),
          ],
        ),
      ),
    );
  }

  Widget normalGraph(double percentage) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.storage,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: size.width * 0.05,
                ),
              ),
              const SizedBox(height: 40.0),
              Text(
                'Free: ${allStorageMap['storage${widget.index}Free']} GB'
                    .replaceAll(regex, ''),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5.0),
              Text(
                'Total: ${allStorageMap['storage${widget.index}Total']} GB',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20.0),
              indicator(
                  (FileManager.useMaterial3
                          ? Theme.of(context).colorScheme.primary
                          : accentColor)
                      .withOpacity(0.3),
                  'Free Space'),
              const SizedBox(height: 5.0),
              indicator(
                  FileManager.useMaterial3
                      ? Theme.of(context).colorScheme.primary
                      : accentColor,
                  'Used Space'),
            ],
          ),
          CircularPercentIndicator(
            radius: 150.0,
            animation: true,
            animationDuration: 1200,
            lineWidth: 10.0,
            percent: percentage,
            center: Text(((allStorageMap['storage${widget.index}Free'] /
                            allStorageMap['storage${widget.index}Total']) *
                        100)
                    .toStringAsFixed(2) +
                '% free'),
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: FileManager.useMaterial3
                ? Theme.of(context).colorScheme.primary
                : accentColor,
            backgroundColor: (FileManager.useMaterial3
                    ? Theme.of(context).colorScheme.primary
                    : accentColor)
                .withOpacity(0.3),
            footer: Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
                right: 10.0,
                top: 20.0,
              ),
              child: Text(
                '${allStorageMap['storage${widget.index}Used'].toStringAsPrecision(4).replaceAll(regex, '')} GB used of ${allStorageMap['storage${widget.index}Total']} GB',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget indicator(Color color, String label) => Row(
        children: [
          Container(
            width: size.width * 0.04,
            height: size.width * 0.04,
            color: color,
          ),
          const SizedBox(width: 10.0),
          Text(label)
        ],
      );
}
