class DomainException implements Exception {
  final String message;
  final dynamic cause;

  const DomainException({
    required this.message,
    this.cause,
  });

  @override
  String toString() => 'DomainException: $message';
}
