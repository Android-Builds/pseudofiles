part of 'getfiles_bloc.dart';

abstract class GetfilesEvent extends Equatable {
  const GetfilesEvent();

  @override
  List<Object> get props => [];
}

class GetAllFiles extends GetfilesEvent {
  const GetAllFiles();
}
