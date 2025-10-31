import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:altura_pos/core/errors/exceptions.dart';
import 'package:altura_pos/core/utils/logger.dart';

/// API interceptor for request/response handling and error handling
class ApiInterceptor extends Interceptor {
  ApiInterceptor({this.authToken});

  String? authToken;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    // Add auth token to headers if available
    if (authToken != null) {
      options.headers['Authorization'] = 'Bearer $authToken';
    }

    // Log request
    Logger.logRequest(
      options.method,
      options.uri.toString(),
      data: options.data,
    );

    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    // Log response
    Logger.logResponse(
      response.requestOptions.method,
      response.requestOptions.uri.toString(),
      response.statusCode ?? 0,
      data: response.data,
    );

    super.onResponse(response, handler);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    // Log error
    Logger.error(
      'API Error: ${err.message}',
      tag: 'API',
      error: err,
      stackTrace: err.stackTrace,
    );

    // Convert DioException to app exceptions
    final exception = _handleError(err);

    // Create new DioException with app exception
    final newError = DioException(
      requestOptions: err.requestOptions,
      error: exception,
      response: err.response,
      type: err.type,
    );

    super.onError(newError, handler);
  }

  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException('Connection timeout');

      case DioExceptionType.badResponse:
        return _handleResponseError(error.response);

      case DioExceptionType.cancel:
        return const NetworkException('Request cancelled');

      case DioExceptionType.connectionError:
        return const NetworkException(
          'No internet connection. Please check your network.',
        );

      case DioExceptionType.badCertificate:
        return const NetworkException('Certificate verification failed');

      case DioExceptionType.unknown:
        return NetworkException(
          'Network error: ${error.message ?? 'Unknown error'}',
        );
    }
  }

  Exception _handleResponseError(Response? response) {
    if (response == null) {
      return const ServerException('No response from server', 0);
    }

    final statusCode = response.statusCode ?? 0;
    final data = response.data;

    // Extract error message from response
    String message = 'Server error';
    if (data is Map<String, dynamic>) {
      message = data['message'] as String? ??
          data['error'] as String? ??
          'Server error';
    }

    switch (statusCode) {
      case 400:
        // Bad request - validation errors
        Map<String, String>? errors;
        if (data is Map<String, dynamic> && data.containsKey('errors')) {
          final errorsData = data['errors'] as Map<String, dynamic>?;
          if (errorsData != null) {
            errors = errorsData.map(
              (key, value) => MapEntry(key, value.toString()),
            );
          }
        }
        return ValidationException(message, errors);

      case 401:
        return AuthenticationException(message);

      case 403:
        return AuthorizationException(message);

      case 404:
        return NotFoundException(message);

      case 422:
        // Unprocessable entity - validation errors
        Map<String, String>? errors;
        if (data is Map<String, dynamic> && data.containsKey('errors')) {
          final errorsData = data['errors'] as Map<String, dynamic>?;
          if (errorsData != null) {
            errors = errorsData.map(
              (key, value) => MapEntry(key, value.toString()),
            );
          }
        }
        return ValidationException(message, errors);

      case 500:
      case 502:
      case 503:
      case 504:
        return ServerException(message, statusCode);

      default:
        return ServerException(message, statusCode);
    }
  }

  /// Update auth token
  void updateAuthToken(String? token) {
    authToken = token;
  }
}

/// Provider for API interceptor
final apiInterceptorProvider = Provider<ApiInterceptor>((ref) {
  return ApiInterceptor();
});
