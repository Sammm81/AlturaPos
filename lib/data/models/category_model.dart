import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:altura_pos/domain/entities/category.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

/// Category data model with JSON serialization
@freezed
class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    required String id,
    required String name,
    String? description,
    @Default(0) int displayOrder,
    @Default(true) bool isActive,
    String? icon,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  const CategoryModel._();

  /// Convert to domain entity
  Category toEntity() => Category(
        id: id,
        name: name,
        description: description,
        displayOrder: displayOrder,
        isActive: isActive,
        icon: icon,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  /// Create from domain entity
  factory CategoryModel.fromEntity(Category entity) => CategoryModel(
        id: entity.id,
        name: entity.name,
        description: entity.description,
        displayOrder: entity.displayOrder,
        isActive: entity.isActive,
        icon: entity.icon,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );
}
