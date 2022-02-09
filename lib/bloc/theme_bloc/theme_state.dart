part of 'theme_bloc.dart';

abstract class ThemeState extends Equatable {
  final bool useMaterial3;
  const ThemeState(this.useMaterial3);

  @override
  List<Object> get props => [useMaterial3];
}

class ThemeChanged extends ThemeState {
  const ThemeChanged(bool useMaterial3) : super(useMaterial3);
}
