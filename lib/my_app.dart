import 'package:bytebeam_assessment/core/themes/app_theme.dart';
import 'package:bytebeam_assessment/feature/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'config/injectors/injectable.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => serviceLocator<ThemeCubit>())],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, theme) {
          return ScreenUtilInit(
            designSize: const Size(384, 832),
            minTextAdapt: true,
            ensureScreenSize: true,
            splitScreenMode: true,
            fontSizeResolver: FontSizeResolvers.radius,
            builder: (context, child) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,

                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: theme.mode.themeMode,
                routerConfig: serviceLocator<GoRouter>(),
              );
            },
          );
        },
      ),
    );
  }
}
