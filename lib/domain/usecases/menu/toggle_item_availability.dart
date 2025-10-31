import 'package:dartz/dartz.dart';
import 'package:altura_pos/core/errors/failures.dart';
import 'package:altura_pos/domain/entities/menu_item.dart';
import 'package:altura_pos/domain/repositories/menu_repository.dart';

/// Use case for toggling menu item availability
class ToggleItemAvailability {
  ToggleItemAvailability(this._repository);

  final MenuRepository _repository;

  Future<Either<Failure, MenuItem>> call(String id, bool isAvailable) async {
    return _repository.toggleAvailability(id, isAvailable);
  }
}
