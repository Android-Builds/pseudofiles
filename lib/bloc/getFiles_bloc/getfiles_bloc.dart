import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pseudofiles/classes/file_manager.dart';

part 'getfiles_event.dart';
part 'getfiles_state.dart';

class GetfilesBloc extends Bloc<GetfilesEvent, GetfilesState> {
  GetfilesBloc() : super(GetfilesInitial()) {
    on<GetAllFiles>((event, emit) async {
      emit(GetfilesFetching());
      List<FileSystemEntity> files = await FileManager.getDirectories();
      emit(GetfilesFetched(files));
    });
  }
}
