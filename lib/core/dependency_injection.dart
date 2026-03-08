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
    instance.registerSingleton<Box>(
      scanHistoryBox,
      instanceName: 'scanHistoryBox',
    );
    instance.registerSingleton<String>(
      'https://highhanded-washier-rima.ngrok-free.dev',
      instanceName: 'appServerUrl',
    );
    instance.registerSingleton<String>(
      'https://highhanded-washier-rima.ngrok-free.dev',
      instanceName: 'weatherApiUrl',
    );
    configureDependencies();
  }
}
