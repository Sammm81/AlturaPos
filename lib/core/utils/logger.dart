import 'dart:developer' as dev;

/// Logging utility with different log levels
class Logger {
  Logger._();

  static const String _name = 'AlturaPos';
  static bool _enableDebugLogs = true;

  /// Enable or disable debug logs
  static void setDebugMode(bool enabled) {
    _enableDebugLogs = enabled;
  }

  /// Log debug message
  static void debug(String message, {String? tag}) {
    if (_enableDebugLogs) {
      dev.log(
        message,
        name: tag ?? _name,
        level: 500,
        time: DateTime.now(),
      );
    }
  }

  /// Log info message
  static void info(String message, {String? tag}) {
    dev.log(
      message,
      name: tag ?? _name,
      level: 800,
      time: DateTime.now(),
    );
  }

  /// Log warning message
  static void warning(String message, {String? tag}) {
    dev.log(
      message,
      name: tag ?? _name,
      level: 900,
      time: DateTime.now(),
    );
  }

  /// Log error message
  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    dev.log(
      message,
      name: tag ?? _name,
      level: 1000,
      error: error,
      stackTrace: stackTrace,
      time: DateTime.now(),
    );
  }

  /// Log API request
  static void logRequest(String method, String url, {Object? data}) {
    if (_enableDebugLogs) {
      debug('[$method] $url ${data != null ? '\nData: $data' : ''}', tag: 'API');
    }
  }

  /// Log API response
  static void logResponse(
    String method,
    String url,
    int statusCode, {
    Object? data,
  }) {
    if (_enableDebugLogs) {
      debug(
        '[$method] $url - $statusCode ${data != null ? '\nResponse: $data' : ''}',
        tag: 'API',
      );
    }
  }

  /// Log database operation
  static void logDatabase(String operation, {String? details}) {
    if (_enableDebugLogs) {
      debug(
        '$operation ${details != null ? '- $details' : ''}',
        tag: 'Database',
      );
    }
  }

  /// Log sync operation
  static void logSync(String message, {String? details}) {
    info(
      '$message ${details != null ? '- $details' : ''}',
      tag: 'Sync',
    );
  }

  /// Log navigation
  static void logNavigation(String from, String to) {
    if (_enableDebugLogs) {
      debug('Navigate: $from → $to', tag: 'Navigation');
    }
  }
}
