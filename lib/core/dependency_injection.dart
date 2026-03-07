import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:kubo_dex/core/dependency_injection.config.dart';
import 'package:shared_preferences/shared_preferences.dart';

@InjectableInit(preferRelativeImports: false)
void configureDependencies() => GetIt.instance.init();

class ServiceLocator {
  ServiceLocator._();

  static final GetIt instance = GetIt.instance;

  static void registerInitialDependencies({
    required SharedPreferences prefs,
    required Box scanHistoryBox,
  }) {
    instance.registerSingleton<SharedPreferences>(prefs);
    instance.registerSingleton<Box>(scanHistoryBox, instanceName: 'scanHistoryBox');
    instance.registerSingleton<String>(
      'http://18.136.103.92:8000',
      instanceName: 'appServerUrl',
    );
    instance.registerSingleton<String>(
      'https://7ff4-2001-fd8-b619-4700-5d40-b3f6-bfc4-ae9c.ngrok-free.app',
      instanceName: 'weatherApiUrl',
    );
    configureDependencies();
  }
}
