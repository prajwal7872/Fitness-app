// ignore_for_file: avoid_print

import 'package:health/health.dart';
import 'dart:convert';

import 'package:intl/intl.dart';

// Future<void> fetchStepData() async {
//   List<HealthDataPoint> _healthDataList = [];
//   int steps = 0;
//   final now = DateTime.now();
//   final midnight = DateTime(now.year, now.month, now.day);

//   bool stepsPermission =
//       await Health().hasPermissions([HealthDataType.STEPS]) ?? false;
//   if (!stepsPermission) {
//     stepsPermission =
//         await Health().requestAuthorization([HealthDataType.STEPS]);
//   }

//   if (stepsPermission) {
//     try {
//       steps = (await Health().getTotalStepsInInterval(midnight, now))!;
//     } catch (error) {
//       print("Exception in getTotalStepsInInterval: $error");
//     }

//     print('Total number of steps: $steps');
//   } else {
//     print("Authorization not granted - error in authorization");
//   }
// }

Future<Map<String, double>> fetchWeeklyStepData() async {
  final now = DateTime.now();
  final midnightOneWeekAgo =
      DateTime(now.year, now.month, now.day).subtract(const Duration(days: 6));

  bool stepsPermission =
      await Health().hasPermissions([HealthDataType.STEPS]) ?? false;

  if (!stepsPermission) {
    try {
      stepsPermission =
          await Health().requestAuthorization([HealthDataType.STEPS]);
    } catch (e) {
      print('Error requesting authorization: $e');
      return {};
    }
  }

  if (!stepsPermission) {
    print("Authorization not granted - error in authorization");
    return {};
  }

  try {
    final stepsData = await Health().getHealthDataFromTypes(
      types: [HealthDataType.STEPS],
      startTime: midnightOneWeekAgo,
      endTime: now,
      includeManualEntry: true,
    );

    final jsonData = jsonEncode(stepsData);
    print("jsonData$jsonData");
    List<dynamic> healthDataList = jsonDecode(jsonData);

    Map<String, double> aggregateStepsByDay(List<dynamic> data) {
      Map<String, double> stepsByDay = {};
      DateFormat dateFormat = DateFormat('EEE', 'en_US');

      for (var entry in data) {
        double steps = (entry['value']['numeric_value'] as num).toDouble();
        String dateStr = entry['date_from'];
        DateTime dateTime = DateTime.parse(dateStr);
        String dayName = dateFormat.format(dateTime);

        if (stepsByDay.containsKey(dayName)) {
          stepsByDay[dayName] = stepsByDay[dayName]! + steps;
        } else {
          stepsByDay[dayName] = steps;
        }
      }

      return stepsByDay;
    }

    return aggregateStepsByDay(healthDataList);
  } catch (error) {
    print("Exception in fetching or processing step data: $error");
    return {};
  }
}
