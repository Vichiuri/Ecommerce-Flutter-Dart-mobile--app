import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@injectableInit

/// This is how to initialize injectable class....NB this code is always like this...never changes
Future<void> configureInjection(String dev) async => await $initGetIt(getIt);

///Environments, Either develpment [dev] or production [rod]
abstract class Env {
  static const dev = 'dev';
  static const prod = 'prod';
}
