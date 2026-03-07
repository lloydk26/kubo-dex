import 'package:dio/dio.dart';
import 'package:kubo_dex/core/infrastructure/exceptions/api_exceptions.dart';

class ErrorUtils {
  ErrorUtils._();

  static ApiException mapDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return NetworkException(error: e);
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          return UnauthorizedException(error: e);
        }
        return ServerException(
          message: e.response?.statusMessage ?? 'Server error',
          statusCode: statusCode,
          error: e,
        );
      default:
        return ApiException(message: e.message ?? 'Unknown error', error: e);
    }
  }
}
