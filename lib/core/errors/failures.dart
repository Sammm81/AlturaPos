import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

/// Base class for all failures in the application
@freezed
class Failure with _$Failure {
  const factory Failure.server({
    required String message,
    int? statusCode,
  }) = ServerFailure;

  const factory Failure.network({
    required String message,
  }) = NetworkFailure;

  const factory Failure.database({
    required String message,
    Object? error,
  }) = DatabaseFailure;

  const factory Failure.authentication({
    required String message,
  }) = AuthenticationFailure;

  const factory Failure.authorization({
    required String message,
  }) = AuthorizationFailure;

  const factory Failure.validation({
    required String message,
    Map<String, String>? errors,
  }) = ValidationFailure;

  const factory Failure.notFound({
    required String message,
  }) = NotFoundFailure;

  const factory Failure.sync({
    required String message,
    String? entityType,
    String? entityId,
  }) = SyncFailure;

  const factory Failure.cache({
    required String message,
  }) = CacheFailure;

  const factory Failure.unknown({
    required String message,
    Object? error,
  }) = UnknownFailure;
}

/// Extension to get user-friendly error messages
extension FailureX on Failure {
  String get userMessage => when(
        server: (message, statusCode) =>
            statusCode == 500
                ? 'Server error. Please try again later.'
                : message,
        network: (message) => 'Network error. Please check your connection.',
        database: (message, error) => 'Database error: $message',
        authentication: (message) => message,
        authorization: (message) => 'Access denied: $message',
        validation: (message, errors) => message,
        notFound: (message) => message,
        sync: (message, entityType, entityId) => 'Sync error: $message',
        cache: (message) => 'Cache error: $message',
        unknown: (message, error) => 'An unexpected error occurred',
      );
}
