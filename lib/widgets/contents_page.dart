import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pseudofiles/bloc/getFiles_bloc/getfiles_bloc.dart';
import 'package:pseudofiles/utils/constants.dart';
import 'package:pseudofiles/widgets/file_list.dart';

class ContentsPage extends StatefulWidget {
  const ContentsPage({Key? key}) : super(key: key);

  @override
  State<ContentsPage> createState() => _ContentsPageState();
}

class _ContentsPageState extends State<ContentsPage> {
  String directory = '';
  List<String> dirPaths = ['Internal'];

  goToDir(String path) {
    BlocProvider.of<GetfilesBloc>(context)
        .add(GetAllFiles(Directory(path).parent.path));
  }

  goToBackDir(String path) {
    BlocProvider.of<GetfilesBloc>(context)
        .add(GetAllFiles(Directory(path).parent.path));
  }

  Future<bool> _onWillPop(String path) async {
    if (path != rootDir) {
      goToBackDir(path);
    } else {
      return (await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you want to exit an App'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        ),
      ));
    }
    return false;
  }

  @override
  void initState() {
    BlocProvider.of<GetfilesBloc>(context).add(const GetAllFiles(''));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetfilesBloc, GetfilesState>(
      builder: (context, state) {
        if (state is GetfilesInitial || state is GetfilesFetching) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is GetfilesFetched) {
          return storageWidget(state.files, state.path);
        } else {
          return const Center(
            child: Text('Error'),
          );
        }
      },
    );
  }

  Widget storageWidget(List<FileSystemEntity> files, String path) =>
      WillPopScope(
        onWillPop: () => _onWillPop(path),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              pinned: false,
              snap: false,
              floating: false,
              toolbarHeight: 40.0,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: EdgeInsets.zero,
                  title: Row(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: dirPaths.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                TextButton(
                                    onPressed: () {
                                      if (dirPaths[index] == 'Internal') {
                                        directory = '';
                                        dirPaths = ['Internal'];
                                        setState(() {});
                                      } else {
                                        goToDir(path);
                                      }
                                    },
                                    child: Text(dirPaths[index])),
                                index == dirPaths.length - 1
                                    ? const SizedBox.shrink()
                                    : const Icon(Icons.arrow_right_sharp),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  )),
            ),
            const SliverToBoxAdapter(
                child: SizedBox(
              height: 10.0,
              child: Divider(thickness: 2.0),
            )),
            SliverToBoxAdapter(
              child: Center(child: FileList(files: files, path: path)),
            ),
          ],
        ),
      );
}
