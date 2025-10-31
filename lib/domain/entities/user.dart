import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

/// User roles enumeration
enum UserRole {
  cashier,
  manager,
  admin,
}

/// User entity
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String username,
    required String fullName,
    required UserRole role,
    String? branchId,
    @Default(true) bool isActive,
    DateTime? lastSyncAt,
    required DateTime createdAt,
  }) = _User;
}
