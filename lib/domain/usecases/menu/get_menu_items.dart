import 'package:dartz/dartz.dart';
import 'package:altura_pos/core/errors/failures.dart';
import 'package:altura_pos/domain/entities/menu_item.dart';
import 'package:altura_pos/domain/repositories/menu_repository.dart';

/// Use case for getting all menu items
class GetMenuItems {
  GetMenuItems(this._repository);

  final MenuRepository _repository;

  Future<Either<Failure, List<MenuItem>>> call() async {
    return _repository.getMenuItems();
  }
}
