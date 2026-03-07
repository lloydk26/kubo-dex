import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kubo_dex/core/dependency_injection.dart';
import 'package:kubo_dex/core/infrastructure/logging/logger.dart';
import 'package:kubo_dex/features/app/presentation/views/init_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    final prefs = await SharedPreferences.getInstance();
    await Hive.initFlutter();
    final scanHistoryBox = await Hive.openBox('scan_history');
    ServiceLocator.registerInitialDependencies(
      prefs: prefs,
      scanHistoryBox: scanHistoryBox,
    );
    runApp(const InitApp());
  }, (e, st) {
    final logger = ServiceLocator.instance<Logger>();
    logger.log(LogLevel.error, '$e', e, st);
  });
}
