import 'package:dartz/dartz.dart';
import 'package:altura_pos/core/errors/failures.dart';
import 'package:altura_pos/domain/entities/order.dart';

/// Order repository interface
abstract class OrderRepository {
  /// Create a new order
  Future<Either<Failure, Order>> createOrder(Order order);

  /// Get order by ID
  Future<Either<Failure, Order>> getOrderById(String id);

  /// Get all orders
  Future<Either<Failure, List<Order>>> getOrders({
    OrderStatus? status,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Get today's orders
  Future<Either<Failure, List<Order>>> getTodayOrders();

  /// Update order
  Future<Either<Failure, Order>> updateOrder(Order order);

  /// Complete order
  Future<Either<Failure, Order>> completeOrder(String id);

  /// Cancel order
  Future<Either<Failure, Order>> cancelOrder(String id);

  /// Get unsynced orders
  Future<Either<Failure, List<Order>>> getUnsyncedOrders();

  /// Mark order as synced
  Future<Either<Failure, void>> markOrderAsSynced(String id);
}
