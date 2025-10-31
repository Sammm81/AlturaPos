import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:altura_pos/core/errors/failures.dart';
import 'package:altura_pos/domain/entities/user.dart';
import 'package:altura_pos/domain/usecases/auth/login_user.dart';
import 'package:altura_pos/domain/usecases/auth/logout_user.dart';
import 'package:altura_pos/domain/usecases/auth/get_current_user.dart';
import 'package:altura_pos/presentation/providers/repository_providers.dart';

/// Authentication state
class AuthState {
  final User? user;
  final bool isLoading;
  final String? errorMessage;
  final bool isAuthenticated;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? errorMessage,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }

  AuthState clearError() {
    return AuthState(
      user: user,
      isLoading: isLoading,
      errorMessage: null,
      isAuthenticated: isAuthenticated,
    );
  }
}

/// Authentication notifier
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._loginUser, this._logoutUser, this._getCurrentUser)
      : super(const AuthState()) {
    _checkAuthStatus();
  }

  final LoginUser _loginUser;
  final LogoutUser _logoutUser;
  final GetCurrentUser _getCurrentUser;

  /// Check if user is already authenticated
  Future<void> _checkAuthStatus() async {
    state = state.copyWith(isLoading: true);

    final result = await _getCurrentUser();

    result.fold(
      (failure) {
        state = const AuthState(isLoading: false, isAuthenticated: false);
      },
      (user) {
        if (user != null) {
          state = AuthState(
            user: user,
            isLoading: false,
            isAuthenticated: true,
          );
        } else {
          state = const AuthState(isLoading: false, isAuthenticated: false);
        }
      },
    );
  }

  /// Login user
  Future<bool> login({
    required String username,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _loginUser(
      username: username,
      password: password,
    );

    return result.fold(
      (failure) {
        final errorMessage = _getErrorMessage(failure);
        state = state.copyWith(
          isLoading: false,
          errorMessage: errorMessage,
          isAuthenticated: false,
        );
        return false;
      },
      (user) {
        state = AuthState(
          user: user,
          isLoading: false,
          isAuthenticated: true,
        );
        return true;
      },
    );
  }

  /// Logout user
  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    final result = await _logoutUser();

    result.fold(
      (failure) {
        // Even if logout fails on server, clear local state
        state = const AuthState(isLoading: false, isAuthenticated: false);
      },
      (_) {
        state = const AuthState(isLoading: false, isAuthenticated: false);
      },
    );
  }

  /// Clear error message
  void clearError() {
    state = state.clearError();
  }

  /// Get error message from failure
  String _getErrorMessage(Failure failure) {
    return failure.when(
      server: (message, statusCode) => message,
      network: (message) => message,
      database: (message, error) => message,
      authentication: (message) => message,
      validation: (message) => message,
      cache: (message) => message,
      unknown: (message) => message,
    );
  }
}

/// Auth provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);

  return AuthNotifier(
    LoginUser(userRepository),
    LogoutUser(userRepository),
    GetCurrentUser(userRepository),
  );
});

/// Current user provider
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authProvider).user;
});

/// Is authenticated provider
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

/// Is loading provider
final isAuthLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isLoading;
});
