part of 'getfiles_bloc.dart';

abstract class GetfilesState extends Equatable {
  const GetfilesState(this.files, this.path);
  final List<FileSystemEntity> files;
  final String path;

  @override
  List<Object> get props => [files, path];
}

class GetfilesInitial extends GetfilesState {
  GetfilesInitial() : super([], '');
}

class GetfilesFetching extends GetfilesState {
  GetfilesFetching() : super([], '');
}

class GetfilesFetched extends GetfilesState {
  const GetfilesFetched(List<FileSystemEntity> files, String path)
      : super(files, path);
}

class GetfilesError extends GetfilesState {
  GetfilesError() : super([], '');
}
