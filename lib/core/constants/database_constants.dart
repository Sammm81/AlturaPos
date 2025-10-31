/// Database constants and table/column names
class DatabaseConstants {
  DatabaseConstants._();

  // Database Info
  static const String databaseName = 'altura_pos.db';
  static const int databaseVersion = 1;

  // Table Names
  static const String usersTable = 'users';
  static const String categoriesTable = 'categories';
  static const String menuItemsTable = 'menu_items';
  static const String variantsTable = 'variants';
  static const String modifiersTable = 'modifiers';
  static const String ordersTable = 'orders';
  static const String orderItemsTable = 'order_items';
  static const String transactionsTable = 'transactions';
  static const String syncQueueTable = 'sync_queue';

  // Common Columns
  static const String id = 'id';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
  static const String isSynced = 'is_synced';
  static const String isActive = 'is_active';

  // User Columns
  static const String username = 'username';
  static const String fullName = 'full_name';
  static const String passwordHash = 'password_hash';
  static const String role = 'role';
  static const String branchId = 'branch_id';
  static const String lastSyncAt = 'last_sync_at';

  // Category Columns
  static const String categoryName = 'name';
  static const String categoryDescription = 'description';
  static const String displayOrder = 'display_order';
  static const String categoryIcon = 'icon';

  // Menu Item Columns
  static const String categoryId = 'category_id';
  static const String itemName = 'name';
  static const String itemDescription = 'description';
  static const String basePrice = 'base_price';
  static const String imageUrl = 'image_url';
  static const String isAvailable = 'is_available';
  static const String hasVariants = 'has_variants';

  // Variant Columns
  static const String menuItemId = 'menu_item_id';
  static const String variantName = 'name';
  static const String priceAdjustment = 'price_adjustment';

  // Modifier Columns
  static const String modifierName = 'name';
  static const String modifierPrice = 'price';
  static const String modifierCategory = 'category';

  // Order Columns
  static const String orderNumber = 'order_number';
  static const String orderType = 'order_type';
  static const String orderStatus = 'status';
  static const String tableNumber = 'table_number';
  static const String customerName = 'customer_name';
  static const String subtotal = 'subtotal';
  static const String taxAmount = 'tax_amount';
  static const String discountAmount = 'discount_amount';
  static const String totalAmount = 'total_amount';
  static const String cashierId = 'cashier_id';
  static const String notes = 'notes';
  static const String completedAt = 'completed_at';

  // Order Item Columns
  static const String orderId = 'order_id';
  static const String menuItemSnapshot = 'menu_item_snapshot';
  static const String selectedVariant = 'selected_variant';
  static const String selectedModifiers = 'selected_modifiers';
  static const String quantity = 'quantity';
  static const String unitPrice = 'unit_price';
  static const String itemTotal = 'item_total';
  static const String itemNotes = 'item_notes';

  // Transaction Columns
  static const String transactionNumber = 'transaction_number';
  static const String paymentMethod = 'payment_method';
  static const String amountPaid = 'amount_paid';
  static const String changeAmount = 'change_amount';
  static const String paymentReference = 'payment_reference';

  // Sync Queue Columns
  static const String entityType = 'entity_type';
  static const String entityId = 'entity_id';
  static const String operation = 'operation';
  static const String payload = 'payload';
  static const String retryCount = 'retry_count';
  static const String lastAttemptAt = 'last_attempt_at';
  static const String syncStatus = 'status';
  static const String errorMessage = 'error_message';

  // Default Values
  static const double defaultTaxRate = 0.10; // 10%
  static const int maxSyncRetries = 5;
  static const int syncRetryDelaySeconds = 60;
  static const int backgroundSyncIntervalMinutes = 15;
}
