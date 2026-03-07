class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic error;

  const ApiException({
    required this.message,
    this.statusCode,
    this.error,
  });

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class NetworkException extends ApiException {
  const NetworkException({
    super.message = 'No internet connection',
    super.statusCode,
    super.error,
  });
}

class ServerException extends ApiException {
  const ServerException({
    super.message = 'Internal server error',
    super.statusCode,
    super.error,
  });
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException({
    super.message = 'Unauthorized',
    super.statusCode = 401,
    super.error,
  });
}
