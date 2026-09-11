part of 'theme_cubit.dart';

final class ThemeState extends Equatable {
  const ThemeState({required this.mode});

  final AppThemeMode mode;

  ThemeState copywith({AppThemeMode? mode}) {
    return ThemeState(mode: mode ?? this.mode);
  }

  @override
  List<Object> get props => [mode];
}
