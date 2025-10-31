class ServerException implements Exception {
  final String message;
  final String? code;

  ServerException(this.message, [this.code]);

  @override
  String toString() => message;
}

class CacheException implements Exception {
  final String message;
  final String? code;

  CacheException(this.message, [this.code]);

  @override
  String toString() => message;
}

class NetworkException implements Exception {
  final String message;
  final String? code;

  NetworkException(this.message, [this.code]);

  @override
  String toString() => message;
}

class AuthenticationException implements Exception {
  final String message;
  final String? code;

  AuthenticationException(this.message, [this.code]);

  @override
  String toString() => message;
}

class ValidationException implements Exception {
  final String message;
  final String? code;

  ValidationException(this.message, [this.code]);

  @override
  String toString() => message;
}

class DatabaseException implements Exception {
  final String message;
  final String? code;

  DatabaseException(this.message, [this.code]);

  @override
  String toString() => message;
}
