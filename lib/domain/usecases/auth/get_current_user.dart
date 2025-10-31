import 'package:dartz/dartz.dart';
import 'package:altura_pos/core/errors/failures.dart';
import 'package:altura_pos/domain/entities/user.dart';
import 'package:altura_pos/domain/repositories/user_repository.dart';

/// Use case for getting current authenticated user
class GetCurrentUser {
  GetCurrentUser(this._repository);

  final UserRepository _repository;

  Future<Either<Failure, User?>> call() async {
    return _repository.getCurrentUser();
  }
}
