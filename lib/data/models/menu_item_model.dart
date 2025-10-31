import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:altura_pos/domain/entities/menu_item.dart';

part 'menu_item_model.freezed.dart';
part 'menu_item_model.g.dart';

/// Variant data model
@freezed
class VariantModel with _$VariantModel {
  const factory VariantModel({
    required String id,
    required String name,
    required double priceAdjustment,
  }) = _VariantModel;

  factory VariantModel.fromJson(Map<String, dynamic> json) =>
      _$VariantModelFromJson(json);

  const VariantModel._();

  Variant toEntity() => Variant(
        id: id,
        name: name,
        priceAdjustment: priceAdjustment,
      );

  factory VariantModel.fromEntity(Variant entity) => VariantModel(
        id: entity.id,
        name: entity.name,
        priceAdjustment: entity.priceAdjustment,
      );
}

/// Modifier data model
@freezed
class ModifierModel with _$ModifierModel {
  const factory ModifierModel({
    required String id,
    required String name,
    required double price,
    required String category,
  }) = _ModifierModel;

  factory ModifierModel.fromJson(Map<String, dynamic> json) =>
      _$ModifierModelFromJson(json);

  const ModifierModel._();

  Modifier toEntity() => Modifier(
        id: id,
        name: name,
        price: price,
        category: category,
      );

  factory ModifierModel.fromEntity(Modifier entity) => ModifierModel(
        id: entity.id,
        name: entity.name,
        price: entity.price,
        category: entity.category,
      );
}

/// Menu item data model with JSON serialization
@freezed
class MenuItemModel with _$MenuItemModel {
  const factory MenuItemModel({
    required String id,
    required String categoryId,
    required String name,
    String? description,
    required double basePrice,
    String? imageUrl,
    @Default(true) bool isAvailable,
    @Default(false) bool hasVariants,
    @Default([]) List<VariantModel> variants,
    @Default([]) List<ModifierModel> modifiers,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _MenuItemModel;

  factory MenuItemModel.fromJson(Map<String, dynamic> json) =>
      _$MenuItemModelFromJson(json);

  const MenuItemModel._();

  /// Convert to domain entity
  MenuItem toEntity() => MenuItem(
        id: id,
        categoryId: categoryId,
        name: name,
        description: description,
        basePrice: basePrice,
        imageUrl: imageUrl,
        isAvailable: isAvailable,
        hasVariants: hasVariants,
        variants: variants.map((v) => v.toEntity()).toList(),
        modifiers: modifiers.map((m) => m.toEntity()).toList(),
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  /// Create from domain entity
  factory MenuItemModel.fromEntity(MenuItem entity) => MenuItemModel(
        id: entity.id,
        categoryId: entity.categoryId,
        name: entity.name,
        description: entity.description,
        basePrice: entity.basePrice,
        imageUrl: entity.imageUrl,
        isAvailable: entity.isAvailable,
        hasVariants: entity.hasVariants,
        variants: entity.variants
            .map((v) => VariantModel.fromEntity(v))
            .toList(),
        modifiers: entity.modifiers
            .map((m) => ModifierModel.fromEntity(m))
            .toList(),
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );
}
