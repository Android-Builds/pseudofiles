import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeChanged(false)) {
    on<ThemeEvent>((event, emit) {
      if (event is ChangeTheme) {
        emit(ThemeChanged(event.useMaterial3));
      }
    });
  }
}
