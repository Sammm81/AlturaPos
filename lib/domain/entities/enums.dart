// Domain entity enumerations
enum UserRole {
  cashier,
  manager,
  admin,
}

enum OrderType {
  dineIn,
  takeAway,
}

enum OrderStatus {
  draft,
  confirmed,
  completed,
  cancelled,
}

enum PaymentMethod {
  cash,
  qris,
  card,
  other,
}

enum SyncOperation {
  create,
  update,
  delete,
}

enum SyncStatus {
  pending,
  inProgress,
  completed,
  failed,
}
