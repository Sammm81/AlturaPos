import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:altura_pos/core/network/api_client.dart';
import 'package:altura_pos/core/network/connectivity_service.dart';
import 'package:altura_pos/data/local/database.dart';
import 'package:altura_pos/data/repositories/user_repository_impl.dart';
import 'package:altura_pos/data/repositories/menu_repository_impl.dart';
import 'package:altura_pos/data/repositories/order_repository_impl.dart';
import 'package:altura_pos/data/repositories/transaction_repository_impl.dart';
import 'package:altura_pos/data/repositories/sync_repository_impl.dart';
import 'package:altura_pos/domain/repositories/user_repository.dart';
import 'package:altura_pos/domain/repositories/menu_repository.dart';
import 'package:altura_pos/domain/repositories/order_repository.dart';
import 'package:altura_pos/domain/repositories/transaction_repository.dart';
import 'package:altura_pos/domain/repositories/sync_repository.dart';

/// Database provider
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

/// API client provider
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

/// Connectivity service provider
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});

/// User repository provider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final database = ref.watch(databaseProvider);
  final apiClient = ref.watch(apiClientProvider);
  final connectivityService = ref.watch(connectivityServiceProvider);

  return UserRepositoryImpl(
    database: database,
    apiClient: apiClient,
    connectivityService: connectivityService,
  );
});

/// Menu repository provider
final menuRepositoryProvider = Provider<MenuRepository>((ref) {
  final database = ref.watch(databaseProvider);
  final apiClient = ref.watch(apiClientProvider);
  final connectivityService = ref.watch(connectivityServiceProvider);

  return MenuRepositoryImpl(
    database: database,
    apiClient: apiClient,
    connectivityService: connectivityService,
  );
});

/// Order repository provider
final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final database = ref.watch(databaseProvider);
  final apiClient = ref.watch(apiClientProvider);
  final connectivityService = ref.watch(connectivityServiceProvider);

  return OrderRepositoryImpl(
    database: database,
    apiClient: apiClient,
    connectivityService: connectivityService,
  );
});

/// Transaction repository provider
final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final database = ref.watch(databaseProvider);
  final apiClient = ref.watch(apiClientProvider);
  final connectivityService = ref.watch(connectivityServiceProvider);

  return TransactionRepositoryImpl(
    database: database,
    apiClient: apiClient,
    connectivityService: connectivityService,
  );
});

/// Sync repository provider
final syncRepositoryProvider = Provider<SyncRepository>((ref) {
  final database = ref.watch(databaseProvider);
  final apiClient = ref.watch(apiClientProvider);
  final connectivityService = ref.watch(connectivityServiceProvider);

  return SyncRepositoryImpl(
    database: database,
    apiClient: apiClient,
    connectivityService: connectivityService,
  );
});
