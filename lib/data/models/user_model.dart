import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:altura_pos/domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// User data model with JSON serialization
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String username,
    required String fullName,
    required String role,
    String? branchId,
    @Default(true) bool isActive,
    DateTime? lastSyncAt,
    required DateTime createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  const UserModel._();

  /// Convert to domain entity
  User toEntity() => User(
        id: id,
        username: username,
        fullName: fullName,
        role: _parseUserRole(role),
        branchId: branchId,
        isActive: isActive,
        lastSyncAt: lastSyncAt,
        createdAt: createdAt,
      );

  /// Create from domain entity
  factory UserModel.fromEntity(User entity) => UserModel(
        id: entity.id,
        username: entity.username,
        fullName: entity.fullName,
        role: entity.role.name,
        branchId: entity.branchId,
        isActive: entity.isActive,
        lastSyncAt: entity.lastSyncAt,
        createdAt: entity.createdAt,
      );

  static UserRole _parseUserRole(String role) {
    switch (role.toLowerCase()) {
      case 'cashier':
        return UserRole.cashier;
      case 'manager':
        return UserRole.manager;
      case 'admin':
        return UserRole.admin;
      default:
        return UserRole.cashier;
    }
  }
}
