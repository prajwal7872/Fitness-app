
import 'package:health/health.dart';
import 'dart:convert';
import 'package:intl/intl.dart';


Future<Map<String, double>> fetchWeeklyCalorieData() async {
  final now = DateTime.now();
  final midnightOneWeekAgo = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 6));

  bool caloriePermission = await Health().hasPermissions([HealthDataType.TOTAL_CALORIES_BURNED]) ?? false;

  if (!caloriePermission) {
    try {
      caloriePermission = await Health().requestAuthorization([HealthDataType.TOTAL_CALORIES_BURNED]);
    } catch (e) {
      print('Error requesting authorization: $e');
      return {};
    }
  }

  if (!caloriePermission) {
    print("Authorization not granted - error in authorization");
    return {};
  }

  try {
    final calorieData = await Health().getHealthDataFromTypes(
      types: [HealthDataType.TOTAL_CALORIES_BURNED],
      startTime: midnightOneWeekAgo,
      endTime: now,
      includeManualEntry: true,
    );

    if (calorieData.isEmpty) {
      print("No data fetched for the given period");
      return {};
    }

    final jsonData = jsonEncode(calorieData);
    print("jsonData: $jsonData");
    List<dynamic> healthDataList = jsonDecode(jsonData);

    Map<String, double> aggregateCalorieByDay(List<dynamic> data) {
      Map<String, double> calorieByDay = {};
      DateFormat dateFormat = DateFormat('EEE', 'en_US');

      for (var entry in data) {
        double calorie = (entry['value']['numeric_value'] as num).toDouble();
        String dateStr = entry['date_from'];
        DateTime dateTime = DateTime.parse(dateStr);
        String dayName = dateFormat.format(dateTime);

        if (calorieByDay.containsKey(dayName)) {
          calorieByDay[dayName] = calorieByDay[dayName]! + calorie;
        } else {
          calorieByDay[dayName] = calorie;
        }
      }

      return calorieByDay;
    }

    return aggregateCalorieByDay(healthDataList);
  } catch (error) {
    print("Exception in fetching or processing calorie data: $error");
    return {};
  }
}


