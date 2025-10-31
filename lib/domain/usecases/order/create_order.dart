import 'package:dartz/dartz.dart';
import 'package:altura_pos/core/errors/failures.dart';
import 'package:altura_pos/domain/entities/order.dart';
import 'package:altura_pos/domain/repositories/order_repository.dart';

/// Use case for creating a new order
class CreateOrder {
  CreateOrder(this._repository);

  final OrderRepository _repository;

  Future<Either<Failure, Order>> call(Order order) async {
    return _repository.createOrder(order);
  }
}
