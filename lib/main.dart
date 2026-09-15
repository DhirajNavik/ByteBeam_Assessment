import 'package:bytebeam_assessment/core/utils/app_startup.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'config/injectors/injectable.dart';
import 'my_app.dart';

void main() async {
  AppStartup.mark();
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getTemporaryDirectory()).path,
    ),
  );
  await configureDependencies();
  runApp(const MyApp());
}
