import 'package:drift/drift.dart';
import 'package:altura_pos/data/local/database.dart';

part 'user_dao.g.dart';

/// Data Access Object for Users table
@DriftAccessor(tables: [Users])
class UserDao extends DatabaseAccessor<AppDatabase> with _$UserDaoMixin {
  UserDao(super.db);

  /// Get user by username
  Future<User?> getUserByUsername(String username) {
    return (select(users)..where((u) => u.username.equals(username)))
        .getSingleOrNull();
  }

  /// Get user by ID
  Future<User?> getUserById(String id) {
    return (select(users)..where((u) => u.id.equals(id))).getSingleOrNull();
  }

  /// Insert user
  Future<int> insertUser(UsersCompanion user) {
    return into(users).insert(user);
  }

  /// Update user
  Future<bool> updateUser(User user) {
    return update(users).replace(user);
  }

  /// Get all active users
  Future<List<User>> getActiveUsers() {
    return (select(users)..where((u) => u.isActive.equals(true))).get();
  }

  /// Update last sync timestamp
  Future<int> updateLastSync(String userId, DateTime timestamp) {
    return (update(users)..where((u) => u.id.equals(userId))).write(
      UsersCompanion(lastSyncAt: Value(timestamp)),
    );
  }
}
