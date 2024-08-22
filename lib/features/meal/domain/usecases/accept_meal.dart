import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class AcceptMealUseCase {
  final Health healthService;

  AcceptMealUseCase(this.healthService);

  Future<void> execute(Map<String, dynamic> mealData) async {
    if (await _requestHealthPermission()) {
      await _writeMealDataToGoogleFit(mealData);
    }
  }

  Future<bool> _requestHealthPermission() async {
    final status = await Permission.activityRecognition.request();
    return status.isGranted;
  }

  Future<void> _writeMealDataToGoogleFit(Map<String, dynamic> mealData) async {
    final DateTime now = DateTime.now();
    final DateTime startTime = DateTime(now.year, now.month, now.day, now.hour);
    final DateTime endTime = startTime.add(const Duration(seconds: 1));

    final double fats =
        double.parse(mealData['nutritionalPlan']['fats'].replaceAll('gm', ''));
    final double carbs =
        double.parse(mealData['nutritionalPlan']['carbs'].replaceAll('gm', ''));
    final double protein = double.parse(
        mealData['nutritionalPlan']['protein'].replaceAll('gm', ''));

    MealType mealType;

    switch (mealData['statusLabel']) {
      case 'Breakfast':
        mealType = MealType.BREAKFAST;
        break;
      case 'Lunch':
        mealType = MealType.LUNCH;
        break;
      case 'Snacks':
        mealType = MealType.SNACK;
        break;
      case 'Dinner':
        mealType = MealType.DINNER;
        break;
      default:
        mealType = MealType.UNKNOWN;
    }

    await healthService.writeMeal(
      mealType: mealType,
      startTime: startTime,
      endTime: endTime,
      caloriesConsumed: fats * 9 + carbs * 4 + protein * 4,
      name: mealData['statusLabel'],
    );
  }
}
