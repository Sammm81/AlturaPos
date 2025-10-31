// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) {
  return _OrderItem.fromJson(json);
}

/// @nodoc
mixin _$OrderItem {
  String get id => throw _privateConstructorUsedError;
  String get menuItemId => throw _privateConstructorUsedError;
  String get menuItemName => throw _privateConstructorUsedError;
  double get basePrice => throw _privateConstructorUsedError;
  Variant? get selectedVariant => throw _privateConstructorUsedError;
  List<Modifier> get selectedModifiers => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  double get unitPrice => throw _privateConstructorUsedError;
  double get itemTotal => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this OrderItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderItemCopyWith<OrderItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderItemCopyWith<$Res> {
  factory $OrderItemCopyWith(OrderItem value, $Res Function(OrderItem) then) =
      _$OrderItemCopyWithImpl<$Res, OrderItem>;
  @useResult
  $Res call({
    String id,
    String menuItemId,
    String menuItemName,
    double basePrice,
    Variant? selectedVariant,
    List<Modifier> selectedModifiers,
    int quantity,
    double unitPrice,
    double itemTotal,
    String? notes,
  });

  $VariantCopyWith<$Res>? get selectedVariant;
}

/// @nodoc
class _$OrderItemCopyWithImpl<$Res, $Val extends OrderItem>
    implements $OrderItemCopyWith<$Res> {
  _$OrderItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? menuItemId = null,
    Object? menuItemName = null,
    Object? basePrice = null,
    Object? selectedVariant = freezed,
    Object? selectedModifiers = null,
    Object? quantity = null,
    Object? unitPrice = null,
    Object? itemTotal = null,
    Object? notes = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            menuItemId: null == menuItemId
                ? _value.menuItemId
                : menuItemId // ignore: cast_nullable_to_non_nullable
                      as String,
            menuItemName: null == menuItemName
                ? _value.menuItemName
                : menuItemName // ignore: cast_nullable_to_non_nullable
                      as String,
            basePrice: null == basePrice
                ? _value.basePrice
                : basePrice // ignore: cast_nullable_to_non_nullable
                      as double,
            selectedVariant: freezed == selectedVariant
                ? _value.selectedVariant
                : selectedVariant // ignore: cast_nullable_to_non_nullable
                      as Variant?,
            selectedModifiers: null == selectedModifiers
                ? _value.selectedModifiers
                : selectedModifiers // ignore: cast_nullable_to_non_nullable
                      as List<Modifier>,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int,
            unitPrice: null == unitPrice
                ? _value.unitPrice
                : unitPrice // ignore: cast_nullable_to_non_nullable
                      as double,
            itemTotal: null == itemTotal
                ? _value.itemTotal
                : itemTotal // ignore: cast_nullable_to_non_nullable
                      as double,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VariantCopyWith<$Res>? get selectedVariant {
    if (_value.selectedVariant == null) {
      return null;
    }

    return $VariantCopyWith<$Res>(_value.selectedVariant!, (value) {
      return _then(_value.copyWith(selectedVariant: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrderItemImplCopyWith<$Res>
    implements $OrderItemCopyWith<$Res> {
  factory _$$OrderItemImplCopyWith(
    _$OrderItemImpl value,
    $Res Function(_$OrderItemImpl) then,
  ) = __$$OrderItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String menuItemId,
    String menuItemName,
    double basePrice,
    Variant? selectedVariant,
    List<Modifier> selectedModifiers,
    int quantity,
    double unitPrice,
    double itemTotal,
    String? notes,
  });

  @override
  $VariantCopyWith<$Res>? get selectedVariant;
}

/// @nodoc
class __$$OrderItemImplCopyWithImpl<$Res>
    extends _$OrderItemCopyWithImpl<$Res, _$OrderItemImpl>
    implements _$$OrderItemImplCopyWith<$Res> {
  __$$OrderItemImplCopyWithImpl(
    _$OrderItemImpl _value,
    $Res Function(_$OrderItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? menuItemId = null,
    Object? menuItemName = null,
    Object? basePrice = null,
    Object? selectedVariant = freezed,
    Object? selectedModifiers = null,
    Object? quantity = null,
    Object? unitPrice = null,
    Object? itemTotal = null,
    Object? notes = freezed,
  }) {
    return _then(
      _$OrderItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        menuItemId: null == menuItemId
            ? _value.menuItemId
            : menuItemId // ignore: cast_nullable_to_non_nullable
                  as String,
        menuItemName: null == menuItemName
            ? _value.menuItemName
            : menuItemName // ignore: cast_nullable_to_non_nullable
                  as String,
        basePrice: null == basePrice
            ? _value.basePrice
            : basePrice // ignore: cast_nullable_to_non_nullable
                  as double,
        selectedVariant: freezed == selectedVariant
            ? _value.selectedVariant
            : selectedVariant // ignore: cast_nullable_to_non_nullable
                  as Variant?,
        selectedModifiers: null == selectedModifiers
            ? _value._selectedModifiers
            : selectedModifiers // ignore: cast_nullable_to_non_nullable
                  as List<Modifier>,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int,
        unitPrice: null == unitPrice
            ? _value.unitPrice
            : unitPrice // ignore: cast_nullable_to_non_nullable
                  as double,
        itemTotal: null == itemTotal
            ? _value.itemTotal
            : itemTotal // ignore: cast_nullable_to_non_nullable
                  as double,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderItemImpl implements _OrderItem {
  const _$OrderItemImpl({
    required this.id,
    required this.menuItemId,
    required this.menuItemName,
    required this.basePrice,
    this.selectedVariant,
    final List<Modifier> selectedModifiers = const [],
    required this.quantity,
    required this.unitPrice,
    required this.itemTotal,
    this.notes,
  }) : _selectedModifiers = selectedModifiers;

  factory _$OrderItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderItemImplFromJson(json);

  @override
  final String id;
  @override
  final String menuItemId;
  @override
  final String menuItemName;
  @override
  final double basePrice;
  @override
  final Variant? selectedVariant;
  final List<Modifier> _selectedModifiers;
  @override
  @JsonKey()
  List<Modifier> get selectedModifiers {
    if (_selectedModifiers is EqualUnmodifiableListView)
      return _selectedModifiers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedModifiers);
  }

  @override
  final int quantity;
  @override
  final double unitPrice;
  @override
  final double itemTotal;
  @override
  final String? notes;

  @override
  String toString() {
    return 'OrderItem(id: $id, menuItemId: $menuItemId, menuItemName: $menuItemName, basePrice: $basePrice, selectedVariant: $selectedVariant, selectedModifiers: $selectedModifiers, quantity: $quantity, unitPrice: $unitPrice, itemTotal: $itemTotal, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.menuItemId, menuItemId) ||
                other.menuItemId == menuItemId) &&
            (identical(other.menuItemName, menuItemName) ||
                other.menuItemName == menuItemName) &&
            (identical(other.basePrice, basePrice) ||
                other.basePrice == basePrice) &&
            (identical(other.selectedVariant, selectedVariant) ||
                other.selectedVariant == selectedVariant) &&
            const DeepCollectionEquality().equals(
              other._selectedModifiers,
              _selectedModifiers,
            ) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.itemTotal, itemTotal) ||
                other.itemTotal == itemTotal) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    menuItemId,
    menuItemName,
    basePrice,
    selectedVariant,
    const DeepCollectionEquality().hash(_selectedModifiers),
    quantity,
    unitPrice,
    itemTotal,
    notes,
  );

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderItemImplCopyWith<_$OrderItemImpl> get copyWith =>
      __$$OrderItemImplCopyWithImpl<_$OrderItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderItemImplToJson(this);
  }
}

abstract class _OrderItem implements OrderItem {
  const factory _OrderItem({
    required final String id,
    required final String menuItemId,
    required final String menuItemName,
    required final double basePrice,
    final Variant? selectedVariant,
    final List<Modifier> selectedModifiers,
    required final int quantity,
    required final double unitPrice,
    required final double itemTotal,
    final String? notes,
  }) = _$OrderItemImpl;

  factory _OrderItem.fromJson(Map<String, dynamic> json) =
      _$OrderItemImpl.fromJson;

  @override
  String get id;
  @override
  String get menuItemId;
  @override
  String get menuItemName;
  @override
  double get basePrice;
  @override
  Variant? get selectedVariant;
  @override
  List<Modifier> get selectedModifiers;
  @override
  int get quantity;
  @override
  double get unitPrice;
  @override
  double get itemTotal;
  @override
  String? get notes;

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderItemImplCopyWith<_$OrderItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
