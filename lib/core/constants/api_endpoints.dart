/// API endpoint constants
class ApiEndpoints {
  ApiEndpoints._();

  // Base URLs (should be configured per environment)
  static const String developmentBaseUrl = 'http://localhost:3000/api';
  static const String stagingBaseUrl = 'https://staging-api.alturapos.com/api';
  static const String productionBaseUrl = 'https://api.alturapos.com/api';

  // Auth Endpoints
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String currentUser = '/auth/me';

  // Menu Endpoints
  static const String menuItems = '/menu/items';
  static const String categories = '/menu/categories';
  static String menuItemById(String id) => '/menu/items/$id';
  static String categoryById(String id) => '/menu/categories/$id';

  // Order Endpoints
  static const String orders = '/orders';
  static String orderById(String id) => '/orders/$id';
  static const String createOrder = '/orders';
  static String updateOrder(String id) => '/orders/$id';
  static String cancelOrder(String id) => '/orders/$id/cancel';

  // Transaction Endpoints
  static const String transactions = '/transactions';
  static String transactionById(String id) => '/transactions/$id';
  static const String createTransaction = '/transactions';

  // Sync Endpoints
  static const String syncPull = '/sync/pull';
  static const String syncPush = '/sync/push';
  static String syncSince(DateTime timestamp) =>
      '/sync/pull?since=${timestamp.toIso8601String()}';

  // Analytics Endpoints
  static const String analytics = '/analytics';
  static const String dailySales = '/analytics/sales/daily';
  static const String topItems = '/analytics/items/top';
  static const String salesByCategory = '/analytics/sales/category';
  static const String salesByHour = '/analytics/sales/hourly';
  static String analyticsDateRange(DateTime start, DateTime end) =>
      '/analytics?start=${start.toIso8601String()}&end=${end.toIso8601String()}';

  // User Endpoints
  static const String users = '/users';
  static String userById(String id) => '/users/$id';
  static const String updateProfile = '/users/profile';

  // Branch Endpoints
  static const String branches = '/branches';
  static String branchById(String id) => '/branches/$id';
}
