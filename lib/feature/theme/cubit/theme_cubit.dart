import 'package:bytebeam_assessment/feature/theme/costants.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

part 'theme_state.dart';

@singleton
class ThemeCubit extends HydratedCubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(mode: AppThemeMode.system));

  void changeTheme(AppThemeMode mode) {
    if (state.mode == mode) return;

    emit(state.copywith(mode: mode));
  }

  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    try {
      return ThemeState(
        mode: AppThemeMode.values.byName(json['mode'] as String),
      );
    } catch (_) {
      return const ThemeState(mode: AppThemeMode.system);
    }
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    return {"mode": state.mode.name};
  }
}
