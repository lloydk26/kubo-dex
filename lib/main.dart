import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kubo_dex/core/dependency_injection.dart';
import 'package:kubo_dex/core/infrastructure/logging/logger.dart';
import 'package:kubo_dex/features/app/presentation/views/init_app.dart';

Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    ServiceLocator.registerInitialDependencies();
    runApp(const InitApp());
  }, (e, st) {
    final logger = ServiceLocator.instance<Logger>();
    logger.log(LogLevel.error, '$e', e, st);
  });
}
