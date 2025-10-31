import 'package:freezed_annotation/freezed_annotation.dart';
import 'variant.dart';
import 'modifier.dart';

part 'menu_item.freezed.dart';
part 'menu_item.g.dart';

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

  factory MenuItem.fromJson(Map<String, dynamic> json) => _$MenuItemFromJson(json);
}
