part of 'getfiles_bloc.dart';

abstract class GetfilesState extends Equatable {
  const GetfilesState(this.files);
  final List<FileSystemEntity> files;

  @override
  List<Object> get props => [files];
}

class GetfilesInitial extends GetfilesState {
  GetfilesInitial() : super([]);
}

class GetfilesFetching extends GetfilesState {
  GetfilesFetching() : super([]);
}

class GetfilesFetched extends GetfilesState {
  const GetfilesFetched(List<FileSystemEntity> files) : super(files);
}

class GetfilesError extends GetfilesState {
  GetfilesError() : super([]);
}
