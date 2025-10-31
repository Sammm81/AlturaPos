import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:altura_pos/core/errors/failures.dart';
import 'package:altura_pos/domain/entities/order.dart';
import 'package:altura_pos/domain/usecases/order/create_order.dart';
import 'package:altura_pos/domain/usecases/order/complete_order.dart';
import 'package:altura_pos/presentation/providers/repository_providers.dart';
import 'package:altura_pos/presentation/providers/cart_provider.dart';
import 'package:altura_pos/presentation/providers/auth_provider.dart';
import 'package:uuid/uuid.dart';

/// Order state
class OrderState {
  final Order? currentOrder;
  final OrderType orderType;
  final String? tableNumber;
  final String? customerName;
  final bool isLoading;
  final String? errorMessage;

  const OrderState({
    this.currentOrder,
    this.orderType = OrderType.dineIn,
    this.tableNumber,
    this.customerName,
    this.isLoading = false,
    this.errorMessage,
  });

  OrderState copyWith({
    Order? currentOrder,
    OrderType? orderType,
    String? tableNumber,
    String? customerName,
    bool? isLoading,
    String? errorMessage,
  }) {
    return OrderState(
      currentOrder: currentOrder ?? this.currentOrder,
      orderType: orderType ?? this.orderType,
      tableNumber: tableNumber ?? this.tableNumber,
      customerName: customerName ?? this.customerName,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  OrderState clearError() {
    return OrderState(
      currentOrder: currentOrder,
      orderType: orderType,
      tableNumber: tableNumber,
      customerName: customerName,
      isLoading: isLoading,
      errorMessage: null,
    );
  }
}

/// Order notifier
class OrderNotifier extends StateNotifier<OrderState> {
  OrderNotifier(
    this._createOrder,
    this._completeOrder,
    this._ref,
  ) : super(const OrderState());

  final CreateOrder _createOrder;
  final CompleteOrder _completeOrder;
  final Ref _ref;
  final _uuid = const Uuid();

  /// Set order type
  void setOrderType(OrderType orderType) {
    state = state.copyWith(orderType: orderType);
  }

  /// Set table number
  void setTableNumber(String? tableNumber) {
    state = state.copyWith(tableNumber: tableNumber);
  }

  /// Set customer name
  void setCustomerName(String? customerName) {
    state = state.copyWith(customerName: customerName);
  }

  /// Create order from cart
  Future<bool> createOrderFromCart() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    // Get cart items
    final cartState = _ref.read(cartProvider);
    if (cartState.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Cart is empty',
      );
      return false;
    }

    // Get current user
    final currentUser = _ref.read(currentUserProvider);
    if (currentUser == null) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'User not authenticated',
      );
      return false;
    }

    // Generate order number
    final orderNumber = _generateOrderNumber();

    // Convert cart items to order items
    final orderItems = cartState.items.map((item) => item.toOrderItem()).toList();

    // Create order entity
    final order = Order(
      id: _uuid.v4(),
      orderNumber: orderNumber,
      orderType: state.orderType,
      status: OrderStatus.draft,
      tableNumber: state.tableNumber,
      customerName: state.customerName,
      items: orderItems,
      subtotal: cartState.subtotal,
      taxAmount: cartState.taxAmount,
      discountAmount: cartState.discountAmount,
      totalAmount: cartState.totalAmount,
      cashierId: currentUser.id,
      branchId: currentUser.branchId ?? '',
      createdAt: DateTime.now(),
    );

    // Save order
    final result = await _createOrder(order);

    return result.fold(
      (failure) {
        final errorMessage = _getErrorMessage(failure);
        state = state.copyWith(
          isLoading: false,
          errorMessage: errorMessage,
        );
        return false;
      },
      (createdOrder) {
        state = state.copyWith(
          currentOrder: createdOrder,
          isLoading: false,
        );
        return true;
      },
    );
  }

  /// Confirm order (change status from draft to confirmed)
  Future<bool> confirmOrder() async {
    if (state.currentOrder == null) {
      state = state.copyWith(errorMessage: 'No order to confirm');
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    final updatedOrder = state.currentOrder!.copyWith(
      status: OrderStatus.confirmed,
    );

    final result = await _createOrder(updatedOrder);

    return result.fold(
      (failure) {
        final errorMessage = _getErrorMessage(failure);
        state = state.copyWith(
          isLoading: false,
          errorMessage: errorMessage,
        );
        return false;
      },
      (order) {
        state = state.copyWith(
          currentOrder: order,
          isLoading: false,
        );
        return true;
      },
    );
  }

  /// Complete order
  Future<bool> completeCurrentOrder() async {
    if (state.currentOrder == null) {
      state = state.copyWith(errorMessage: 'No order to complete');
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _completeOrder(state.currentOrder!.id);

    return result.fold(
      (failure) {
        final errorMessage = _getErrorMessage(failure);
        state = state.copyWith(
          isLoading: false,
          errorMessage: errorMessage,
        );
        return false;
      },
      (completedOrder) {
        state = state.copyWith(
          currentOrder: completedOrder,
          isLoading: false,
        );
        return true;
      },
    );
  }

  /// Cancel current order
  void cancelOrder() {
    // Clear cart
    _ref.read(cartProvider.notifier).clear();
    
    // Reset order state
    state = const OrderState();
  }

  /// Start new order (clear everything)
  void startNewOrder() {
    // Clear cart
    _ref.read(cartProvider.notifier).clear();
    
    // Reset order state
    state = const OrderState();
  }

  /// Clear error message
  void clearError() {
    state = state.clearError();
  }

  /// Generate order number
  String _generateOrderNumber() {
    final now = DateTime.now();
    final timestamp = now.millisecondsSinceEpoch;
    return 'ORD${timestamp.toString().substring(timestamp.toString().length - 8)}';
  }

  /// Get error message from failure
  String _getErrorMessage(Failure failure) {
    return failure.when(
      server: (message, statusCode) => message,
      network: (message) => message,
      database: (message, error) => message,
      authentication: (message) => message,
      validation: (message) => message,
      cache: (message) => message,
      unknown: (message) => message,
    );
  }
}

/// Order provider
final orderProvider = StateNotifierProvider<OrderNotifier, OrderState>((ref) {
  final orderRepository = ref.watch(orderRepositoryProvider);

  return OrderNotifier(
    CreateOrder(orderRepository),
    CompleteOrder(orderRepository),
    ref,
  );
});

/// Current order provider
final currentOrderProvider = Provider<Order?>((ref) {
  return ref.watch(orderProvider).currentOrder;
});

/// Order type provider
final orderTypeProvider = Provider<OrderType>((ref) {
  return ref.watch(orderProvider).orderType;
});

/// Is order loading provider
final isOrderLoadingProvider = Provider<bool>((ref) {
  return ref.watch(orderProvider).isLoading;
});
