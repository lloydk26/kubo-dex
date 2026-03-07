import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

const appServerUrl = Named('appServerUrl');

@lazySingleton
class DioProvider {
  Dio create<T>() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    return dio;
  }
}
