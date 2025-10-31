class OrderModel {
  final int? id;
  final String orderNumber;
  final String orderType;
  final String paymentMethod;
  final int subtotal;
  final int tax;
  final int total;
  final String status;
  final String syncStatus;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? syncedAt;
  final String? customerName;
  final String? tableNumber;
  final String? notes;

  OrderModel({
    this.id,
    required this.orderNumber,
    required this.orderType,
    required this.paymentMethod,
    required this.subtotal,
    required this.tax,
    required this.total,
    this.status = 'Completed',
    this.syncStatus = 'Pending',
    DateTime? createdAt,
    this.updatedAt,
    this.syncedAt,
    this.customerName,
    this.tableNumber,
    this.notes,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderNumber': orderNumber,
      'orderType': orderType,
      'paymentMethod': paymentMethod,
      'subtotal': subtotal,
      'tax': tax,
      'total': total,
      'status': status,
      'syncStatus': syncStatus,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'syncedAt': syncedAt?.toIso8601String(),
      'customerName': customerName,
      'tableNumber': tableNumber,
      'notes': notes,
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as int?,
      orderNumber: json['orderNumber'] as String,
      orderType: json['orderType'] as String,
      paymentMethod: json['paymentMethod'] as String,
      subtotal: json['subtotal'] as int,
      tax: json['tax'] as int,
      total: json['total'] as int,
      status: json['status'] as String? ?? 'Completed',
      syncStatus: json['syncStatus'] as String? ?? 'Pending',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
      syncedAt: json['syncedAt'] != null ? DateTime.parse(json['syncedAt'] as String) : null,
      customerName: json['customerName'] as String?,
      tableNumber: json['tableNumber'] as String?,
      notes: json['notes'] as String?,
    );
  }

  OrderModel copyWith({
    int? id,
    String? orderNumber,
    String? orderType,
    String? paymentMethod,
    int? subtotal,
    int? tax,
    int? total,
    String? status,
    String? syncStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? syncedAt,
    String? customerName,
    String? tableNumber,
    String? notes,
  }) {
    return OrderModel(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      orderType: orderType ?? this.orderType,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      status: status ?? this.status,
      syncStatus: syncStatus ?? this.syncStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      customerName: customerName ?? this.customerName,
      tableNumber: tableNumber ?? this.tableNumber,
      notes: notes ?? this.notes,
    );
  }
}
