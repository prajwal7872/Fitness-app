import 'package:health/health.dart';
import 'dart:convert';

import 'package:intl/intl.dart';

Future<void> fetchStepData() async {
  List<HealthDataPoint> _healthDataList = [];
  int steps = 0;
  // get steps for today (i.e., since midnight)
  final now = DateTime.now();
  final midnight = DateTime(now.year, now.month, now.day);

  bool stepsPermission =
      await Health().hasPermissions([HealthDataType.STEPS]) ?? false;
  if (!stepsPermission) {
    stepsPermission =
        await Health().requestAuthorization([HealthDataType.STEPS]);
  }

  if (stepsPermission) {
    try {
      steps = (await Health().getTotalStepsInInterval(midnight, now))!;
    } catch (error) {
      print("Exception in getTotalStepsInInterval: $error");
    }

    print('Total number of steps: $steps');
  } else {
    print("Authorization not granted - error in authorization");
  }
}



Future<Map<String, double>> fetchWeeklyStepData() async {
  // Get the date one week ago from midnight in UTC timezone
  final now = DateTime.now();
  final midnightOneWeekAgo =
      DateTime(now.year, now.month, now.day).subtract(const Duration(days: 6));

  // Check permissions for accessing Health data
  bool stepsPermission =
      await Health().hasPermissions([HealthDataType.STEPS]) ?? false;
  if (!stepsPermission) {
    stepsPermission =
        await Health().requestAuthorization([HealthDataType.STEPS]);
  }

  if (!stepsPermission) {
    print("Authorization not granted - error in authorization");
    return {};
  }

  try {
    // Fetch steps data from Health
    final stepsData = await Health().getHealthDataFromTypes(
      types: [HealthDataType.STEPS],
      startTime: midnightOneWeekAgo,
      endTime: now,
      includeManualEntry: true,
    );

    // Parse the JSON data
    final jsonData = jsonEncode(stepsData);
    List<dynamic> healthDataList = jsonDecode(jsonData);
    // Function to aggregate steps by day of the week
print('healthdata$healthDataList');
    Map<String, double> aggregateStepsByDay(List<dynamic> data) {
      Map<String, double> stepsByDay = {};
      DateFormat dateFormat =
          DateFormat('EEE', 'en_US'); // Format to get the day name

      for (var entry in data) {
        double steps = (entry['value']['numeric_value'] as num).toDouble();
        String dateStr = entry['date_from'];

        // Parse the date in UTC timezone
        DateTime dateTime = DateTime.parse(dateStr);

        // Format the date to get the day name (e.g., Sun, Mon, etc.)
        String dayName = dateFormat.format(dateTime);

        if (stepsByDay.containsKey(dayName)) {
          stepsByDay[dayName] = stepsByDay[dayName]! + steps;
        } else {
          stepsByDay[dayName] = steps;
        }
      }

      return stepsByDay;
    }

    // Aggregate steps by day of the week
    Map<String, double> totalStepsByDay = aggregateStepsByDay(healthDataList);
    //healthKitBloc.add(WeeklyStepsEvent(totalStepsByDay));

    return totalStepsByDay;
  } catch (error) {
    print("Exception in fetching or processing step data: $error");
    return {};
  }
}
