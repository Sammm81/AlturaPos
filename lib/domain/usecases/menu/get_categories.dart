import 'package:dartz/dartz.dart';
import 'package:altura_pos/core/errors/failures.dart';
import 'package:altura_pos/domain/entities/category.dart';
import 'package:altura_pos/domain/repositories/menu_repository.dart';

/// Use case for getting all categories
class GetCategories {
  GetCategories(this._repository);

  final MenuRepository _repository;

  Future<Either<Failure, List<Category>>> call() async {
    return _repository.getCategories();
  }
}
