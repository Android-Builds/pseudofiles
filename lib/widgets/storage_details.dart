import 'package:flutter/material.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/utils/constants.dart';
import 'package:pseudofiles/widgets/storage_graph.dart';

class StorageDetails extends StatefulWidget {
  const StorageDetails({Key? key, required this.manager}) : super(key: key);
  final FileManager manager;

  @override
  State<StorageDetails> createState() => _StorageDetailsState();
}

class _StorageDetailsState extends State<StorageDetails>
    with TickerProviderStateMixin {
  late TabController tabController;
  int index = 0;
  @override
  void initState() {
    super.initState();
    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.manager.getStorageInfo(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Map map = snapshot.data as Map;
          return Container(
            margin: const EdgeInsets.all(10.0),
            height: size.height * 0.35,
            width: size.width,
            decoration: BoxDecoration(
              //color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Stack(
              children: [
                PageView(
                  onPageChanged: (value) {
                    setState(() => tabController.index = value);
                  },
                  children: List.generate(
                      map.keys.length ~/ 2,
                      (index) => StorageGraph(
                            available: map['storage_${index + 1}_Available'],
                            total: map['storage_${index + 1}_Total'],
                            storage:
                                index == 0 ? 'Internal \nStorage' : 'SD Card',
                          )),
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
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
