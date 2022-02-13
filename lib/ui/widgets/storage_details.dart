import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/ui/widgets/storage_graph.dart';
import 'package:pseudofiles/utils/constants.dart';

import '../../bloc/theme_bloc/theme_bloc.dart';
import '../../utils/themes.dart';

class StorageDetails extends StatefulWidget {
  const StorageDetails({Key? key}) : super(key: key);

  @override
  State<StorageDetails> createState() => _StorageDetailsState();
}

class _StorageDetailsState extends State<StorageDetails>
    with TickerProviderStateMixin {
  late TabController tabController;
  int index = 0;

  void initTabController() async {
    tabController = TabController(
      initialIndex: 0,
      length: (await FileManager.getRootDirectories()).length,
      vsync: this,
    );
  }

  void saveStorageData(Map map, int index) {
    double availableStorage = double.parse(
        map['storage_${index + 1}_Available'].toString().split(' ')[0]);
    double totalStorage = double.parse(
        map['storage_${index + 1}_Total'].toString().split(' ')[0]);
    allStorageMap['storage${index + 1}Free'] =
        double.parse(availableStorage.toStringAsPrecision(4));
    allStorageMap['storage${index + 1}Total'] =
        double.parse(totalStorage.toStringAsPrecision(4));
    allStorageMap['storage${index + 1}Used'] =
        double.parse((totalStorage - availableStorage).toStringAsPrecision(4));
  }

  @override
  void initState() {
    initTabController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FileManager.getStorageInfo(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Map map = snapshot.data as Map;
          return BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              if (state is CompactnessChanged) {
                FileManager.useCompactUi = state.useCompactUi;
              }
              return Container(
                margin: const EdgeInsets.all(10.0),
                height: size.height *
                    (FileManager.useCompactUi
                        ? (map.keys.length * (0.27 / 4) + 0.04)
                        : 0.35),
                width: size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: FileManager.useCompactUi
                    ? compactWidget(map)
                    : normalWidget(map),
              );
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget normalWidget(Map map) {
    return Stack(
      children: [
        PageView(
          onPageChanged: (value) {
            setState(() => tabController.index = value);
          },
          children: List.generate(map.keys.length ~/ 2, (index) {
            saveStorageData(map, index);
            return StorageGraph(
              index: index + 1,
              storage: index == 0 ? 'Internal \nStorage' : 'SD Card',
            );
          }),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TabPageSelector(
              indicatorSize: size.width * 0.02,
              controller: tabController,
            ),
          ),
        ),
      ],
    );
  }

  Widget compactWidget(Map map) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
            children: List.generate((map.keys.length ~/ 2) + 1, (index) {
          if (index < map.keys.length ~/ 2) {
            saveStorageData(map, index);
            return StorageGraph(
              index: index + 1,
              storage: index == 0 ? 'Internal Storage' : 'SD Card',
            );
          } else {
            return Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 10.0),
              child: Row(
                children: [
                  indicator(
                    (FileManager.useMaterial3
                            ? Theme.of(context).colorScheme.secondary
                            : accentColor)
                        .withOpacity(0.3),
                    'Free',
                  ),
                  const SizedBox(width: 10.0),
                  indicator(
                    FileManager.useMaterial3
                        ? Theme.of(context).colorScheme.secondary
                        : accentColor,
                    'Used',
                  ),
                ],
              ),
            );
          }
        })),
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
