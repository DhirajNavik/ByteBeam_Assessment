import 'package:flutter/material.dart';

import 'config/injectors/injectable.dart';
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  configureDependencies();
  runApp(const MyApp());
}
