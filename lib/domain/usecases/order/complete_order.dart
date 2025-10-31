import 'package:dartz/dartz.dart';
import 'package:altura_pos/core/errors/failures.dart';
import 'package:altura_pos/domain/entities/order.dart';
import 'package:altura_pos/domain/repositories/order_repository.dart';

/// Use case for completing an order
class CompleteOrder {
  CompleteOrder(this._repository);

  final OrderRepository _repository;

  Future<Either<Failure, Order>> call(String orderId) async {
    return _repository.completeOrder(orderId);
  }
}
