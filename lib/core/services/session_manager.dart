import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:altura_pos/core/utils/logger.dart';

/// Service for managing user sessions with secure storage
class SessionManager {
  SessionManager({
    FlutterSecureStorage? secureStorage,
  }) : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _secureStorage;

  // Storage keys
  static const String _keyAuthToken = 'auth_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUserId = 'user_id';
  static const String _keyUsername = 'username';
  static const String _keyUserRole = 'user_role';
  static const String _keyBranchId = 'branch_id';
  static const String _keyLastLoginAt = 'last_login_at';

  /// Save auth token
  Future<void> saveAuthToken(String token) async {
    try {
      await _secureStorage.write(key: _keyAuthToken, value: token);
      Logger.logInfo('Auth token saved successfully');
    } catch (e) {
      Logger.logError('Failed to save auth token', error: e);
      rethrow;
    }
  }

  /// Get auth token
  Future<String?> getAuthToken() async {
    try {
      return await _secureStorage.read(key: _keyAuthToken);
    } catch (e) {
      Logger.logError('Failed to read auth token', error: e);
      return null;
    }
  }

  /// Save refresh token
  Future<void> saveRefreshToken(String token) async {
    try {
      await _secureStorage.write(key: _keyRefreshToken, value: token);
      Logger.logInfo('Refresh token saved successfully');
    } catch (e) {
      Logger.logError('Failed to save refresh token', error: e);
      rethrow;
    }
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    try {
      return await _secureStorage.read(key: _keyRefreshToken);
    } catch (e) {
      Logger.logError('Failed to read refresh token', error: e);
      return null;
    }
  }

  /// Save user session data
  Future<void> saveUserSession({
    required String userId,
    required String username,
    required String userRole,
    String? branchId,
  }) async {
    try {
      await Future.wait([
        _secureStorage.write(key: _keyUserId, value: userId),
        _secureStorage.write(key: _keyUsername, value: username),
        _secureStorage.write(key: _keyUserRole, value: userRole),
        if (branchId != null)
          _secureStorage.write(key: _keyBranchId, value: branchId),
        _secureStorage.write(
          key: _keyLastLoginAt,
          value: DateTime.now().toIso8601String(),
        ),
      ]);
      Logger.logInfo('User session saved successfully');
    } catch (e) {
      Logger.logError('Failed to save user session', error: e);
      rethrow;
    }
  }

  /// Get user ID
  Future<String?> getUserId() async {
    try {
      return await _secureStorage.read(key: _keyUserId);
    } catch (e) {
      Logger.logError('Failed to read user ID', error: e);
      return null;
    }
  }

  /// Get username
  Future<String?> getUsername() async {
    try {
      return await _secureStorage.read(key: _keyUsername);
    } catch (e) {
      Logger.logError('Failed to read username', error: e);
      return null;
    }
  }

  /// Get user role
  Future<String?> getUserRole() async {
    try {
      return await _secureStorage.read(key: _keyUserRole);
    } catch (e) {
      Logger.logError('Failed to read user role', error: e);
      return null;
    }
  }

  /// Get branch ID
  Future<String?> getBranchId() async {
    try {
      return await _secureStorage.read(key: _keyBranchId);
    } catch (e) {
      Logger.logError('Failed to read branch ID', error: e);
      return null;
    }
  }

  /// Get last login time
  Future<DateTime?> getLastLoginAt() async {
    try {
      final value = await _secureStorage.read(key: _keyLastLoginAt);
      if (value == null) return null;
      return DateTime.tryParse(value);
    } catch (e) {
      Logger.logError('Failed to read last login time', error: e);
      return null;
    }
  }

  /// Check if user has active session
  Future<bool> hasActiveSession() async {
    try {
      final token = await getAuthToken();
      final userId = await getUserId();
      return token != null && userId != null;
    } catch (e) {
      Logger.logError('Failed to check active session', error: e);
      return false;
    }
  }

  /// Clear all session data (logout)
  Future<void> clearSession() async {
    try {
      await _secureStorage.deleteAll();
      Logger.logInfo('Session cleared successfully');
    } catch (e) {
      Logger.logError('Failed to clear session', error: e);
      rethrow;
    }
  }

  /// Clear specific key
  Future<void> clearKey(String key) async {
    try {
      await _secureStorage.delete(key: key);
      Logger.logInfo('Key $key cleared successfully');
    } catch (e) {
      Logger.logError('Failed to clear key $key', error: e);
      rethrow;
    }
  }

  /// Get all stored values (for debugging - use with caution)
  Future<Map<String, String>> getAllValues() async {
    try {
      return await _secureStorage.readAll();
    } catch (e) {
      Logger.logError('Failed to read all values', error: e);
      return {};
    }
  }
}
