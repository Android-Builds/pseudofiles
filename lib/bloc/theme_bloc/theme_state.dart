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

class ThemeModeChanged extends ThemeState {
  final ThemeMode themeMode;
  const ThemeModeChanged(this.themeMode) : super(themeMode);
}

class BottomNavbarHidden extends ThemeState {
  final bool hideBottomNavbar;
  const BottomNavbarHidden(this.hideBottomNavbar) : super(hideBottomNavbar);
}
