part of 'theme_bloc.dart';

abstract class ThemeState extends Equatable {
  final dynamic value;
  const ThemeState(this.value);

  @override
  List<Object> get props => [value];
}

class ThemeChanged extends ThemeState {
  const ThemeChanged(bool useMaterial3) : super(useMaterial3);
}

class CompactnessChanged extends ThemeState {
  final bool useCompactUi;
  const CompactnessChanged(this.useCompactUi) : super(useCompactUi);
}
