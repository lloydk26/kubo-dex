import 'dart:developer' as developer;

import 'package:injectable/injectable.dart';

enum LogLevel { debug, info, warning, error }

abstract interface class Logger {
  void log(LogLevel level, String message, [Object? error, StackTrace? stackTrace]);
}

@LazySingleton(as: Logger)
class AppLogger implements Logger {
  @override
  void log(LogLevel level, String message, [Object? error, StackTrace? stackTrace]) {
    developer.log(
      message,
      name: level.name.toUpperCase(),
      error: error,
      stackTrace: stackTrace,
    );
  }
}
