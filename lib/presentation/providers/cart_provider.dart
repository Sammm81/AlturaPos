import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:altura_pos/core/constants/database_constants.dart';
import 'package:altura_pos/domain/entities/menu_item.dart';
import 'package:altura_pos/domain/entities/order.dart';
import 'package:uuid/uuid.dart';

/// Cart item (represents an item in the shopping cart)
class CartItem {
  final String id;
  final MenuItem menuItem;
  final Variant? selectedVariant;
  final List<Modifier> selectedModifiers;
  final int quantity;
  final String? notes;
  final double unitPrice;
  final double itemTotal;

  CartItem({
    required this.id,
    required this.menuItem,
    this.selectedVariant,
    this.selectedModifiers = const [],
    required this.quantity,
    this.notes,
    required this.unitPrice,
    required this.itemTotal,
  });

  CartItem copyWith({
    String? id,
    MenuItem? menuItem,
    Variant? selectedVariant,
    List<Modifier>? selectedModifiers,
    int? quantity,
    String? notes,
    double? unitPrice,
    double? itemTotal,
  }) {
    return CartItem(
      id: id ?? this.id,
      menuItem: menuItem ?? this.menuItem,
      selectedVariant: selectedVariant ?? this.selectedVariant,
      selectedModifiers: selectedModifiers ?? this.selectedModifiers,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
      unitPrice: unitPrice ?? this.unitPrice,
      itemTotal: itemTotal ?? this.itemTotal,
    );
  }

  /// Convert to OrderItem entity
  OrderItem toOrderItem() {
    return OrderItem(
      id: id,
      menuItemId: menuItem.id,
      menuItemName: menuItem.name,
      basePrice: menuItem.basePrice,
      selectedVariant: selectedVariant,
      selectedModifiers: selectedModifiers,
      quantity: quantity,
      unitPrice: unitPrice,
      itemTotal: itemTotal,
      notes: notes,
    );
  }
}

/// Cart state
class CartState {
  final List<CartItem> items;
  final double subtotal;
  final double taxAmount;
  final double discountAmount;
  final double totalAmount;
  final double taxRate;

  const CartState({
    this.items = const [],
    this.subtotal = 0.0,
    this.taxAmount = 0.0,
    this.discountAmount = 0.0,
    this.totalAmount = 0.0,
    this.taxRate = DatabaseConstants.defaultTaxRate,
  });

  CartState copyWith({
    List<CartItem>? items,
    double? subtotal,
    double? taxAmount,
    double? discountAmount,
    double? totalAmount,
    double? taxRate,
  }) {
    return CartState(
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      taxAmount: taxAmount ?? this.taxAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      taxRate: taxRate ?? this.taxRate,
    );
  }

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  bool get isEmpty => items.isEmpty;

  bool get isNotEmpty => items.isNotEmpty;
}

/// Cart notifier
class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(const CartState());

  final _uuid = const Uuid();

  /// Add item to cart
  void addItem({
    required MenuItem menuItem,
    Variant? selectedVariant,
    List<Modifier> selectedModifiers = const [],
    int quantity = 1,
    String? notes,
  }) {
    // Calculate unit price
    double unitPrice = menuItem.basePrice;
    
    if (selectedVariant != null) {
      unitPrice = selectedVariant.price;
    }
    
    // Add modifier prices
    for (final modifier in selectedModifiers) {
      unitPrice += modifier.price;
    }

    final itemTotal = unitPrice * quantity;

    // Check if same item with same modifiers exists
    final existingIndex = state.items.indexWhere((item) =>
        item.menuItem.id == menuItem.id &&
        item.selectedVariant?.id == selectedVariant?.id &&
        _areModifiersEqual(item.selectedModifiers, selectedModifiers));

    if (existingIndex != -1) {
      // Update existing item quantity
      final existingItem = state.items[existingIndex];
      final updatedQuantity = existingItem.quantity + quantity;
      final updatedItemTotal = unitPrice * updatedQuantity;

      final updatedItem = existingItem.copyWith(
        quantity: updatedQuantity,
        itemTotal: updatedItemTotal,
      );

      final updatedItems = List<CartItem>.from(state.items);
      updatedItems[existingIndex] = updatedItem;

      state = state.copyWith(items: updatedItems);
    } else {
      // Add new item
      final cartItem = CartItem(
        id: _uuid.v4(),
        menuItem: menuItem,
        selectedVariant: selectedVariant,
        selectedModifiers: selectedModifiers,
        quantity: quantity,
        notes: notes,
        unitPrice: unitPrice,
        itemTotal: itemTotal,
      );

      state = state.copyWith(items: [...state.items, cartItem]);
    }

    _recalculate();
  }

  /// Update item quantity
  void updateItemQuantity(String itemId, int quantity) {
    if (quantity <= 0) {
      removeItem(itemId);
      return;
    }

    final updatedItems = state.items.map((item) {
      if (item.id == itemId) {
        final updatedItemTotal = item.unitPrice * quantity;
        return item.copyWith(
          quantity: quantity,
          itemTotal: updatedItemTotal,
        );
      }
      return item;
    }).toList();

    state = state.copyWith(items: updatedItems);
    _recalculate();
  }

  /// Update item notes
  void updateItemNotes(String itemId, String notes) {
    final updatedItems = state.items.map((item) {
      if (item.id == itemId) {
        return item.copyWith(notes: notes);
      }
      return item;
    }).toList();

    state = state.copyWith(items: updatedItems);
  }

  /// Remove item from cart
  void removeItem(String itemId) {
    final updatedItems = state.items.where((item) => item.id != itemId).toList();
    state = state.copyWith(items: updatedItems);
    _recalculate();
  }

  /// Clear all items from cart
  void clear() {
    state = const CartState();
  }

  /// Apply discount
  void applyDiscount(double discountAmount) {
    state = state.copyWith(discountAmount: discountAmount);
    _recalculate();
  }

  /// Set tax rate
  void setTaxRate(double taxRate) {
    state = state.copyWith(taxRate: taxRate);
    _recalculate();
  }

  /// Recalculate totals
  void _recalculate() {
    double subtotal = 0.0;

    for (final item in state.items) {
      subtotal += item.itemTotal;
    }

    final taxAmount = subtotal * state.taxRate;
    final totalAmount = subtotal + taxAmount - state.discountAmount;

    state = state.copyWith(
      subtotal: subtotal,
      taxAmount: taxAmount,
      totalAmount: totalAmount,
    );
  }

  /// Check if two modifier lists are equal
  bool _areModifiersEqual(List<Modifier> a, List<Modifier> b) {
    if (a.length != b.length) return false;

    final aIds = a.map((m) => m.id).toSet();
    final bIds = b.map((m) => m.id).toSet();

    return aIds.containsAll(bIds) && bIds.containsAll(aIds);
  }
}

/// Cart provider
final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});

/// Cart item count provider
final cartItemCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).itemCount;
});

/// Cart is empty provider
final cartIsEmptyProvider = Provider<bool>((ref) {
  return ref.watch(cartProvider).isEmpty;
});

/// Cart total provider
final cartTotalProvider = Provider<double>((ref) {
  return ref.watch(cartProvider).totalAmount;
});
