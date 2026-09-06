import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'config/injectors/injectable.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: serviceLocator<GoRouter>(),
    );
  }
}
