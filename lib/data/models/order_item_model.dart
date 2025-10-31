class OrderItemModel {
  final int? id;
  final int? orderId;
  final String itemName;
  final int quantity;
  final int price;
  final int total;
  final String? category;
  final String? notes;
  final DateTime createdAt;

  OrderItemModel({
    this.id,
    this.orderId,
    required this.itemName,
    required this.quantity,
    required this.price,
    int? total,
    this.category,
    this.notes,
    DateTime? createdAt,
  })  : total = total ?? (quantity * price),
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'itemName': itemName,
      'quantity': quantity,
      'price': price,
      'total': total,
      'category': category,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as int?,
      orderId: json['orderId'] as int?,
      itemName: json['itemName'] as String,
      quantity: json['quantity'] as int,
      price: json['price'] as int,
      total: json['total'] as int?,
      category: json['category'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  OrderItemModel copyWith({
    int? id,
    int? orderId,
    String? itemName,
    int? quantity,
    int? price,
    int? total,
    String? category,
    String? notes,
    DateTime? createdAt,
  }) {
    return OrderItemModel(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      itemName: itemName ?? this.itemName,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      total: total ?? this.total,
      category: category ?? this.category,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
