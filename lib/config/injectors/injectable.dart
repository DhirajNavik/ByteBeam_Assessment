import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import "injectable.config.dart";

final serviceLocator = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
void configureDependencies() => serviceLocator.init();
