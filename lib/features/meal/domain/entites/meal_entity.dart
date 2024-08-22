class Meal {
  final String statusLabel;
  final NutritionalPlan nutritionalPlan;

  Meal({
    required this.statusLabel,
    required this.nutritionalPlan,
  });
}

class NutritionalPlan {
  final double fats;
  final double carbs;
  final double protein;
  final double iron;

  NutritionalPlan({
    required this.fats,
    required this.carbs,
    required this.protein,
    required this.iron,
  });
}
