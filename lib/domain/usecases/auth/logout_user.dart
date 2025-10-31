import 'package:dartz/dartz.dart';
import 'package:altura_pos/core/errors/failures.dart';
import 'package:altura_pos/domain/repositories/user_repository.dart';

/// Use case for user logout
class LogoutUser {
  LogoutUser(this._repository);

  final UserRepository _repository;

  Future<Either<Failure, void>> call() async {
    return _repository.logout();
  }
}
