import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeChanged(false)) {
    on<ThemeEvent>((event, emit) {
      if (event is ChangeTheme) {
        emit(ThemeChanged(event.useMaterial3));
      } else if (event is ChangeCompactness) {
        emit(CompactnessChanged(event.useCompactTheme));
      } else if (event is ChangeThemeMode) {
        emit(ThemeModeChanged(event.themeMode));
      } else if (event is HideBottomNavbar) {
        emit(BottomNavbarHidden(event.hideBottomNavbar));
      }
    });
  }
}
