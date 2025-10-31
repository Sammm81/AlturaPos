import 'package:freezed_annotation/freezed_annotation.dart';

part 'menu_item.freezed.dart';

/// Variant value object
@freezed
class Variant with _$Variant {
  const factory Variant({
    required String id,
    required String name,
    required double priceAdjustment,
  }) = _Variant;
}

/// Modifier value object
@freezed
class Modifier with _$Modifier {
  const factory Modifier({
    required String id,
    required String name,
    required double price,
    required String category,
  }) = _Modifier;
}

/// Menu item entity
@freezed
class MenuItem with _$MenuItem {
  const factory MenuItem({
    required String id,
    required String categoryId,
    required String name,
    String? description,
    required double basePrice,
    String? imageUrl,
    @Default(true) bool isAvailable,
    @Default(false) bool hasVariants,
    @Default([]) List<Variant> variants,
    @Default([]) List<Modifier> modifiers,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _MenuItem;
}
