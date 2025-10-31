import 'package:dartz/dartz.dart';
import 'package:altura_pos/core/errors/failures.dart';
import 'package:altura_pos/domain/entities/user.dart';

/// User repository interface
abstract class UserRepository {
  /// Authenticate user with username and password
  Future<Either<Failure, User>> login({
    required String username,
    required String password,
  });

  /// Logout current user
  Future<Either<Failure, void>> logout();

  /// Get current authenticated user
  Future<Either<Failure, User?>> getCurrentUser();

  /// Get user by ID
  Future<Either<Failure, User>> getUserById(String id);

  /// Update user profile
  Future<Either<Failure, User>> updateUser(User user);

  /// Check if user session is valid
  Future<Either<Failure, bool>> isSessionValid();
}
