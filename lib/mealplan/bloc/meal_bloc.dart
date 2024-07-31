// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/health.dart';
import 'package:loginpage/mealplan/bloc/meal_event.dart';
import 'package:loginpage/mealplan/bloc/meal_state.dart';
import 'package:permission_handler/permission_handler.dart';

class MealBloc extends Bloc<MealEvent, MealState> {
  Timer? _timer;

  MealBloc() : super(MealInitial()) {
    on<LoadStatusDataEvent>((event, emit) {
      final List<Map<String, dynamic>> statusData = [
        {
          "image": 'assets/images/receipe.jpg',
          "statusLabel": "Breakfast",
          "mealDescription": "Breakfast Meal description",
          "nutritionalPlan": {
            "fats": "5gm",
            "carbs": "40gm",
            "protein": "20gm",
            "iron": "1gm"
          },
          "waterCount": 3,
          "recipeLink": "https://flutter.dev"
        },
        {
          "image": "assets/images/lunch.jpg",
          "statusLabel": "Lunch",
          "mealDescription": "Lunch Meal description",
          "nutritionalPlan": {
            "fats": "50gm",
            "carbs": "30gm",
            "protein": "20gm",
            "iron": "1gm"
          },
          "waterCount": 1,
          "recipeLink": "https://flutter.dev"
        },
        {
          "image": "assets/images/snacks.jpg",
          "statusLabel": "Snacks",
          "mealDescription": "Snacks Meal description",
          "nutritionalPlan": {
            "fats": "25gm",
            "carbs": "20gm",
            "protein": "20gm",
            "iron": "1gm"
          },
          "waterCount": 1,
          "recipeLink": "https://facebook.com"
        },
        {
          "image": "assets/images/dinner.jpg",
          "statusLabel": "Dinner",
          "mealDescription": "Dinner Meal description",
          "nutritionalPlan": {
            "fats": "5gm",
            "carbs": "50gm",
            "protein": "30gm",
            "iron": "1gm"
          },
          "waterCount": 1,
          "recipeLink": "https://youtube.com"
        }
      ];

      emit(MealPlanLoaded(
          statusData,
          List<bool>.filled(statusData.length, false),
          List<bool>.filled(statusData.length, false),
          0,
          true,
          0,
          -1,
          0,
          ''));
      _startAutoRejectTimer();
    });

    on<AcceptMealEvent>((event, emit) async {
      final state = this.state as MealPlanLoaded;
      final acceptedMeals = List<bool>.from(state.acceptedMeals);

      if (state.currentMealIndex < acceptedMeals.length) {
        acceptedMeals[state.currentMealIndex] = true;
      }
      final nextMealIndex = state.currentMealIndex < state.statusData.length - 1
          ? state.currentMealIndex + 1
          : state.currentMealIndex;

      if (await _requestHealthPermission()) {
        await _writeMealDataToGoogleFit(
            state.statusData[state.currentMealIndex]);
      }

      String updateMessage = '';
      if (nextMealIndex == state.statusData.length - 1) {
        if (acceptedMeals.where((meal) => meal).length +
                state.rejectedMeals.where((meal) => meal).length ==
            state.statusData.length) {
          updateMessage = 'Your meal plan is updated for today';
        }
      }

      emit(MealPlanLoaded(
        state.statusData,
        acceptedMeals,
        state.rejectedMeals,
        nextMealIndex,
        true,
        nextMealIndex,
        state.selectedBottleIndex,
        state.waterIntake,
        updateMessage,
      ));

      if (state.currentMealIndex == 3) {
        emit(MealPlanLoaded(
          state.statusData,
          acceptedMeals,
          state.rejectedMeals,
          nextMealIndex,
          false,
          state.currentMealIndex,
          state.selectedBottleIndex,
          state.waterIntake,
          updateMessage,
        ));
      }
    });

    on<RejectMealEvent>((event, emit) {
      final state = this.state as MealPlanLoaded;
      final rejectedMeals = List<bool>.from(state.rejectedMeals);

      if (state.currentMealIndex < rejectedMeals.length) {
        rejectedMeals[state.currentMealIndex] = true;
      }
      final nextMealIndex = state.currentMealIndex < state.statusData.length - 1
          ? state.currentMealIndex + 1
          : state.currentMealIndex;

      String updateMessage = '';
      if (nextMealIndex == state.statusData.length - 1) {
        if (state.acceptedMeals.where((meal) => meal).length +
                rejectedMeals.where((meal) => meal).length ==
            state.statusData.length) {
          updateMessage = 'Your meal plan is updated for today';
        }
      }

      emit(MealPlanLoaded(
        state.statusData,
        state.acceptedMeals,
        rejectedMeals,
        nextMealIndex,
        true,
        nextMealIndex,
        -1,
        0,
        updateMessage,
      ));

      if (state.currentMealIndex == 3) {
        emit(MealPlanLoaded(
          state.statusData,
          state.acceptedMeals,
          rejectedMeals,
          nextMealIndex,
          false,
          nextMealIndex,
          -1,
          0,
          updateMessage,
        ));
      }
    });

    on<ShowMealDescriptionEvent>((event, emit) async {
      final state = this.state as MealPlanLoaded;
      bool showAcceptButton = event.mealIndex == state.currentMealIndex &&
          state.currentMealIndex < state.statusData.length - 1;

      emit(MealPlanLoaded(
          state.statusData,
          state.acceptedMeals,
          state.rejectedMeals,
          state.currentMealIndex,
          showAcceptButton,
          event.mealIndex,
          -1,
          0,
          state.updateMessage));

      if (event.mealIndex != state.currentMealIndex) {
        await Future.delayed(const Duration(seconds: 5));
        final currentState = this.state as MealPlanLoaded;
        if (currentState.selectedMealIndex == event.mealIndex) {
          emit(MealPlanLoaded(
              currentState.statusData,
              currentState.acceptedMeals,
              currentState.rejectedMeals,
              currentState.currentMealIndex,
              currentState.currentMealIndex <
                  currentState.statusData.length - 1,
              currentState.currentMealIndex,
              -1,
              0,
              currentState.updateMessage));
        }
      }
    });

    on<SelectBottleEvent>((event, emit) async {
      final state = this.state as MealPlanLoaded;
      final newWaterIntake = (event.bottleIndex + 1) * 1000;

      emit(MealPlanLoaded(
          state.statusData,
          state.acceptedMeals,
          state.rejectedMeals,
          state.currentMealIndex,
          state.showAcceptButton,
          state.selectedMealIndex,
          event.bottleIndex,
          newWaterIntake,
          state.updateMessage));
      await _recordWaterIntake(newWaterIntake);
    });
  }
  Future<bool> _requestHealthPermission() async {
    final status = await Permission.activityRecognition.request();
    if (status.isGranted) {
      return true;
    } else {
      print("Health write permission denied");
      return false;
    }
  }

  Future<void> _writeMealDataToGoogleFit(Map<String, dynamic> mealData) async {
    final Health health = Health();

    final DateTime now = DateTime.now();
    final DateTime startTime = DateTime(now.year, now.month, now.day, now.hour);
    final DateTime endTime = startTime.add(const Duration(seconds: 1));

    final double fats =
        double.parse(mealData['nutritionalPlan']['fats'].replaceAll('gm', ''));
    final double carbs =
        double.parse(mealData['nutritionalPlan']['carbs'].replaceAll('gm', ''));
    final double protein = double.parse(
        mealData['nutritionalPlan']['protein'].replaceAll('gm', ''));

    bool success = false;
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

    success = await health.writeMeal(
      mealType: mealType,
      startTime: startTime,
      endTime: endTime,
      caloriesConsumed: fats * 9 + carbs * 4 + protein * 4,
      name: mealData['statusLabel'],
    );

    if (success) {
      print("Successfully wrote meal data to Google Fit");
    } else {
      print("Failed to write meal data to Google Fit");
    }
  }

  void _startAutoRejectTimer() {
    _timer = Timer.periodic(const Duration(seconds: 0), (timer) {
      final now = DateTime.now();

      final state = this.state;
      if (state is MealPlanLoaded) {
        final currentMealIndex = state.currentMealIndex;
        final currentMealData = state.statusData[currentMealIndex];

        if (!state.rejectedMeals[currentMealIndex] &&
            !state.acceptedMeals[currentMealIndex]) {
          if (currentMealData['statusLabel'] == 'Breakfast' &&
              now.hour >= 9 &&
              now.minute >= 0) {
            add(RejectMealEvent());
          } else if (currentMealData['statusLabel'] == 'Lunch' &&
              now.hour >= 13 &&
              now.minute >= 0) {
            add(RejectMealEvent());
          } else if (currentMealData['statusLabel'] == 'Snacks' &&
              now.hour >= 17 &&
              now.minute >= 0) {
            add(RejectMealEvent());
          } else if (currentMealData['statusLabel'] == 'Dinner' &&
              now.hour >= 21 &&
              now.minute >= 0) {
            add(RejectMealEvent());
          }
        }
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  Future<void> _recordWaterIntake(int waterIntake) async {
    bool granted = await Permission.activityRecognition.request().isGranted;
    if (!granted) {
      granted = await Permission.activityRecognition.request().isGranted;
    }
    if (!granted) return;

    final DateTime now = DateTime.now();
    final DateTime startTime = now.subtract(const Duration(seconds: 1));
    HealthDataType waterType = HealthDataType.WATER;

    bool success = await Health().writeHealthData(
      value: waterIntake / 1000.0,
      type: waterType,
      startTime: startTime,
      endTime: now,
    );

    if (success) {
      print("Successfully wrote water intake data to Google Fit");
    } else {
      print("Failed to write water intake data to Google Fit");
    }
  }
}
