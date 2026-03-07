import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:kubo_dex/core/dependency_injection.config.dart';

@InjectableInit(preferRelativeImports: false)
void configureDependencies() => GetIt.instance.init();

class ServiceLocator {
  ServiceLocator._();

  static final GetIt instance = GetIt.instance;

  static void registerInitialDependencies() {
    instance.registerSingleton<String>(
      'http://18.136.103.92:8000',
      instanceName: 'appServerUrl',
    );
    configureDependencies();
  }
}
