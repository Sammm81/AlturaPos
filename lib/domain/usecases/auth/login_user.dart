import 'package:dartz/dartz.dart';
import 'package:altura_pos/core/errors/failures.dart';
import 'package:altura_pos/domain/entities/user.dart';
import 'package:altura_pos/domain/repositories/user_repository.dart';

/// Use case for user login
class LoginUser {
  LoginUser(this._repository);

  final UserRepository _repository;

  Future<Either<Failure, User>> call({
    required String username,
    required String password,
  }) async {
    return _repository.login(username: username, password: password);
  }
}
