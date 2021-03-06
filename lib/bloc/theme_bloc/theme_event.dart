part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class ChangeTheme extends ThemeEvent {
  final bool useMaterial3;
  const ChangeTheme(this.useMaterial3);
}

class ChangeCompactness extends ThemeEvent {
  final bool useCompactTheme;
  const ChangeCompactness(this.useCompactTheme);
}

class ChangeThemeMode extends ThemeEvent {
  final ThemeMode themeMode;
  const ChangeThemeMode(this.themeMode);
}

class HideBottomNavbar extends ThemeEvent {
  final bool hideBottomNavbar;
  const HideBottomNavbar(this.hideBottomNavbar);
}
