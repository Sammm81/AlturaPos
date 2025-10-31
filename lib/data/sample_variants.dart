import 'models/variant_models.dart';

/// Sample variant configurations for different menu items
class SampleVariants {
  static List<VariantGroup> getBurgerVariants() {
    return [
      VariantGroup(
        id: 'size',
        name: 'Size',
        isRequired: true,
        isMultiple: false,
        options: [
          VariantOption(id: 's1', label: 'Small', extraPrice: 0),
          VariantOption(id: 's2', label: 'Medium', extraPrice: 5000),
          VariantOption(id: 's3', label: 'Large', extraPrice: 10000),
        ],
      ),
      VariantGroup(
        id: 'addons',
        name: 'Add-ons',
        isRequired: false,
        isMultiple: true,
        maxSelection: 3,
        options: [
          VariantOption(id: 'a1', label: 'Extra Cheese', extraPrice: 5000),
          VariantOption(id: 'a2', label: 'Double Patty', extraPrice: 15000),
          VariantOption(id: 'a3', label: 'Bacon', extraPrice: 8000),
          VariantOption(id: 'a4', label: 'Mushroom', extraPrice: 6000),
        ],
      ),
      VariantGroup(
        id: 'doneness',
        name: 'Doneness',
        isRequired: true,
        isMultiple: false,
        options: [
          VariantOption(id: 'd1', label: 'Well Done', extraPrice: 0),
          VariantOption(id: 'd2', label: 'Medium', extraPrice: 0),
          VariantOption(id: 'd3', label: 'Medium Rare', extraPrice: 0),
        ],
      ),
    ];
  }

  static List<VariantGroup> getPizzaVariants() {
    return [
      VariantGroup(
        id: 'size',
        name: 'Size',
        isRequired: true,
        isMultiple: false,
        options: [
          VariantOption(id: 's1', label: 'Personal (8")', extraPrice: 0),
          VariantOption(id: 's2', label: 'Medium (12")', extraPrice: 15000),
          VariantOption(id: 's3', label: 'Large (16")', extraPrice: 25000),
          VariantOption(id: 's4', label: 'Extra Large (20")', extraPrice: 40000),
        ],
      ),
      VariantGroup(
        id: 'crust',
        name: 'Crust Type',
        isRequired: true,
        isMultiple: false,
        options: [
          VariantOption(id: 'c1', label: 'Thin Crust', extraPrice: 0),
          VariantOption(id: 'c2', label: 'Regular', extraPrice: 0),
          VariantOption(id: 'c3', label: 'Thick Crust', extraPrice: 5000),
          VariantOption(id: 'c4', label: 'Stuffed Crust', extraPrice: 10000),
        ],
      ),
      VariantGroup(
        id: 'toppings',
        name: 'Extra Toppings',
        isRequired: false,
        isMultiple: true,
        maxSelection: 5,
        options: [
          VariantOption(id: 't1', label: 'Extra Cheese', extraPrice: 8000),
          VariantOption(id: 't2', label: 'Pepperoni', extraPrice: 12000),
          VariantOption(id: 't3', label: 'Mushrooms', extraPrice: 7000),
          VariantOption(id: 't4', label: 'Bell Peppers', extraPrice: 6000),
          VariantOption(id: 't5', label: 'Olives', extraPrice: 6000),
          VariantOption(id: 't6', label: 'Pineapple', extraPrice: 7000),
        ],
      ),
    ];
  }

  static List<VariantGroup> getCoffeeVariants() {
    return [
      VariantGroup(
        id: 'size',
        name: 'Size',
        isRequired: true,
        isMultiple: false,
        options: [
          VariantOption(id: 's1', label: 'Small', extraPrice: 0),
          VariantOption(id: 's2', label: 'Medium', extraPrice: 5000),
          VariantOption(id: 's3', label: 'Large', extraPrice: 8000),
        ],
      ),
      VariantGroup(
        id: 'temperature',
        name: 'Temperature',
        isRequired: true,
        isMultiple: false,
        options: [
          VariantOption(id: 'temp1', label: 'Hot', extraPrice: 0),
          VariantOption(id: 'temp2', label: 'Iced', extraPrice: 2000),
        ],
      ),
      VariantGroup(
        id: 'sugar',
        name: 'Sugar Level',
        isRequired: true,
        isMultiple: false,
        options: [
          VariantOption(id: 'sg1', label: 'No Sugar', extraPrice: 0),
          VariantOption(id: 'sg2', label: 'Less Sugar (25%)', extraPrice: 0),
          VariantOption(id: 'sg3', label: 'Half Sugar (50%)', extraPrice: 0),
          VariantOption(id: 'sg4', label: 'Normal (100%)', extraPrice: 0),
          VariantOption(id: 'sg5', label: 'Extra Sweet', extraPrice: 2000),
        ],
      ),
      VariantGroup(
        id: 'addons',
        name: 'Add-ons',
        isRequired: false,
        isMultiple: true,
        maxSelection: 3,
        options: [
          VariantOption(id: 'a1', label: 'Extra Shot', extraPrice: 8000),
          VariantOption(id: 'a2', label: 'Whipped Cream', extraPrice: 5000),
          VariantOption(id: 'a3', label: 'Vanilla Syrup', extraPrice: 5000),
          VariantOption(id: 'a4', label: 'Caramel Syrup', extraPrice: 5000),
          VariantOption(id: 'a5', label: 'Hazelnut Syrup', extraPrice: 5000),
        ],
      ),
    ];
  }

  static List<VariantGroup> getDrinkVariants() {
    return [
      VariantGroup(
        id: 'size',
        name: 'Size',
        isRequired: true,
        isMultiple: false,
        options: [
          VariantOption(id: 's1', label: 'Regular', extraPrice: 0),
          VariantOption(id: 's2', label: 'Large', extraPrice: 5000),
        ],
      ),
      VariantGroup(
        id: 'ice',
        name: 'Ice Level',
        isRequired: true,
        isMultiple: false,
        options: [
          VariantOption(id: 'i1', label: 'No Ice', extraPrice: 0),
          VariantOption(id: 'i2', label: 'Less Ice', extraPrice: 0),
          VariantOption(id: 'i3', label: 'Normal Ice', extraPrice: 0),
          VariantOption(id: 'i4', label: 'Extra Ice', extraPrice: 0),
        ],
      ),
      VariantGroup(
        id: 'sugar',
        name: 'Sugar Level',
        isRequired: true,
        isMultiple: false,
        options: [
          VariantOption(id: 'sg1', label: 'No Sugar', extraPrice: 0),
          VariantOption(id: 'sg2', label: 'Less Sugar', extraPrice: 0),
          VariantOption(id: 'sg3', label: 'Normal', extraPrice: 0),
        ],
      ),
    ];
  }

  static List<VariantGroup> getSaladVariants() {
    return [
      VariantGroup(
        id: 'size',
        name: 'Size',
        isRequired: true,
        isMultiple: false,
        options: [
          VariantOption(id: 's1', label: 'Regular', extraPrice: 0),
          VariantOption(id: 's2', label: 'Large', extraPrice: 10000),
        ],
      ),
      VariantGroup(
        id: 'dressing',
        name: 'Dressing',
        isRequired: true,
        isMultiple: false,
        options: [
          VariantOption(id: 'd1', label: 'Caesar', extraPrice: 0),
          VariantOption(id: 'd2', label: 'Ranch', extraPrice: 0),
          VariantOption(id: 'd3', label: 'Italian', extraPrice: 0),
          VariantOption(id: 'd4', label: 'Balsamic', extraPrice: 2000),
        ],
      ),
      VariantGroup(
        id: 'protein',
        name: 'Add Protein',
        isRequired: false,
        isMultiple: false,
        options: [
          VariantOption(id: 'p1', label: 'Grilled Chicken', extraPrice: 15000),
          VariantOption(id: 'p2', label: 'Grilled Salmon', extraPrice: 25000),
          VariantOption(id: 'p3', label: 'Boiled Egg', extraPrice: 8000),
        ],
      ),
    ];
  }

  static List<VariantGroup> getPastaVariants() {
    return [
      VariantGroup(
        id: 'size',
        name: 'Portion Size',
        isRequired: true,
        isMultiple: false,
        options: [
          VariantOption(id: 's1', label: 'Regular', extraPrice: 0),
          VariantOption(id: 's2', label: 'Large', extraPrice: 12000),
        ],
      ),
      VariantGroup(
        id: 'spice',
        name: 'Spice Level',
        isRequired: true,
        isMultiple: false,
        options: [
          VariantOption(id: 'sp1', label: 'Mild', extraPrice: 0),
          VariantOption(id: 'sp2', label: 'Medium', extraPrice: 0),
          VariantOption(id: 'sp3', label: 'Hot', extraPrice: 0),
          VariantOption(id: 'sp4', label: 'Extra Hot', extraPrice: 0),
        ],
      ),
      VariantGroup(
        id: 'extras',
        name: 'Extras',
        isRequired: false,
        isMultiple: true,
        maxSelection: 3,
        options: [
          VariantOption(id: 'e1', label: 'Extra Cheese', extraPrice: 8000),
          VariantOption(id: 'e2', label: 'Meatballs', extraPrice: 12000),
          VariantOption(id: 'e3', label: 'Garlic Bread', extraPrice: 10000),
        ],
      ),
    ];
  }

  /// Get variants based on item name
  static List<VariantGroup> getVariantsForItem(String itemName) {
    final lowercaseName = itemName.toLowerCase();
    
    if (lowercaseName.contains('burger')) {
      return getBurgerVariants();
    } else if (lowercaseName.contains('pizza')) {
      return getPizzaVariants();
    } else if (lowercaseName.contains('coffee')) {
      return getCoffeeVariants();
    } else if (lowercaseName.contains('juice') || lowercaseName.contains('soda')) {
      return getDrinkVariants();
    } else if (lowercaseName.contains('salad')) {
      return getSaladVariants();
    } else if (lowercaseName.contains('pasta')) {
      return getPastaVariants();
    }
    
    // Default variants for items without specific configuration
    return [
      VariantGroup(
        id: 'size',
        name: 'Size',
        isRequired: true,
        isMultiple: false,
        options: [
          VariantOption(id: 's1', label: 'Regular', extraPrice: 0),
          VariantOption(id: 's2', label: 'Large', extraPrice: 5000),
        ],
      ),
    ];
  }
}
