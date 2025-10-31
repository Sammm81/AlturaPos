/// Base class for all exceptions in the application
class AppException implements Exception {
  const AppException(this.message, [this.statusCode]);

  final String message;
  final int? statusCode;

  @override
  String toString() => 'AppException: $message';
}

/// Server-side exceptions
class ServerException extends AppException {
  const ServerException(super.message, [super.statusCode]);

  @override
  String toString() => 'ServerException: $message (Status: $statusCode)';
}

/// Network-related exceptions
class NetworkException extends AppException {
  const NetworkException(super.message);

  @override
  String toString() => 'NetworkException: $message';
}

/// Database-related exceptions
class DatabaseException extends AppException {
  const DatabaseException(super.message, [this.originalError]);

  final Object? originalError;

  @override
  String toString() =>
      'DatabaseException: $message ${originalError != null ? '($originalError)' : ''}';
}

/// Authentication exceptions
class AuthenticationException extends AppException {
  const AuthenticationException(super.message);

  @override
  String toString() => 'AuthenticationException: $message';
}

/// Authorization exceptions
class AuthorizationException extends AppException {
  const AuthorizationException(super.message);

  @override
  String toString() => 'AuthorizationException: $message';
}

/// Validation exceptions
class ValidationException extends AppException {
  const ValidationException(super.message, [this.errors]);

  final Map<String, String>? errors;

  @override
  String toString() =>
      'ValidationException: $message ${errors != null ? '(Errors: $errors)' : ''}';
}

/// Resource not found exceptions
class NotFoundException extends AppException {
  const NotFoundException(super.message);

  @override
  String toString() => 'NotFoundException: $message';
}

/// Synchronization exceptions
class SyncException extends AppException {
  const SyncException(super.message, [this.entityType, this.entityId]);

  final String? entityType;
  final String? entityId;

  @override
  String toString() =>
      'SyncException: $message ${entityType != null ? '(Type: $entityType, ID: $entityId)' : ''}';
}

/// Cache-related exceptions
class CacheException extends AppException {
  const CacheException(super.message);

  @override
  String toString() => 'CacheException: $message';
}
