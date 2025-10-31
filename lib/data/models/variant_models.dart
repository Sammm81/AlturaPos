/// Variant and modifier models for menu items
class VariantGroup {
  final String id;
  final String name;
  final bool isRequired;
  final bool isMultiple; // true = multiple select, false = single select
  final int? minSelection;
  final int? maxSelection;
  final List<VariantOption> options;

  VariantGroup({
    required this.id,
    required this.name,
    this.isRequired = false,
    this.isMultiple = false,
    this.minSelection,
    this.maxSelection,
    required this.options,
  });

  VariantGroup copyWith({
    String? id,
    String? name,
    bool? isRequired,
    bool? isMultiple,
    int? minSelection,
    int? maxSelection,
    List<VariantOption>? options,
  }) {
    return VariantGroup(
      id: id ?? this.id,
      name: name ?? this.name,
      isRequired: isRequired ?? this.isRequired,
      isMultiple: isMultiple ?? this.isMultiple,
      minSelection: minSelection ?? this.minSelection,
      maxSelection: maxSelection ?? this.maxSelection,
      options: options ?? this.options,
    );
  }
}

class VariantOption {
  final String id;
  final String label;
  final int extraPrice; // in Rupiah
  bool selected;

  VariantOption({
    required this.id,
    required this.label,
    this.extraPrice = 0,
    this.selected = false,
  });

  VariantOption copyWith({
    String? id,
    String? label,
    int? extraPrice,
    bool? selected,
  }) {
    return VariantOption(
      id: id ?? this.id,
      label: label ?? this.label,
      extraPrice: extraPrice ?? this.extraPrice,
      selected: selected ?? this.selected,
    );
  }
}

class CustomizedItem {
  final String itemId;
  final String itemName;
  final int basePrice;
  final String category;
  final Map<String, List<VariantOption>> selectedVariants;
  final int quantity;
  final String? specialNotes;
  final int totalPrice;

  CustomizedItem({
    required this.itemId,
    required this.itemName,
    required this.basePrice,
    required this.category,
    required this.selectedVariants,
    required this.quantity,
    this.specialNotes,
    required this.totalPrice,
  });

  String getVariantSummary() {
    if (selectedVariants.isEmpty) return '';
    
    final variants = <String>[];
    selectedVariants.forEach((groupName, options) {
      final optionLabels = options.map((opt) => opt.label).join(', ');
      variants.add('$groupName: $optionLabels');
    });
    
    return variants.join(' • ');
  }

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'itemName': itemName,
      'basePrice': basePrice,
      'category': category,
      'selectedVariants': selectedVariants.map(
        (key, value) => MapEntry(
          key,
          value.map((opt) => {
            'id': opt.id,
            'label': opt.label,
            'extraPrice': opt.extraPrice,
          }).toList(),
        ),
      ),
      'quantity': quantity,
      'specialNotes': specialNotes,
      'totalPrice': totalPrice,
    };
  }
}
