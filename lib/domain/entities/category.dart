import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';

/// Category entity
@freezed
class Category with _$Category {
  const factory Category({
    required String id,
    required String name,
    String? description,
    @Default(0) int displayOrder,
    @Default(true) bool isActive,
    String? icon,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Category;
}
