// ignore_for_file: avoid_print
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/health.dart';
import 'package:loginpage/features/meal/domain/usecases/accept_meal.dart';
import 'package:loginpage/features/meal/domain/usecases/reject_meal.dart';
import 'package:loginpage/features/meal/presentation/bloc/meal_event.dart';
import 'package:loginpage/features/meal/presentation/bloc/meal_state.dart';
import 'package:loginpage/features/meal/presentation/services/permission.dart';
import 'package:permission_handler/permission_handler.dart';

class MealBloc extends Bloc<MealEvent, MealState> {
  final AcceptMealUseCase acceptMealUseCase;
  final RejectMealUseCase rejectMealUseCase;

  Timer? _timer;
  Timer? _showButtonTimer;
  Timer? _countdownTimer;

  MealBloc({
    required this.acceptMealUseCase,
    required this.rejectMealUseCase,
  }) : super(MealInitial()) {
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
            "iron": "1gm",
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
            "iron": "1gm",
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
            "iron": "1gm",
          },
          "waterCount": 2,
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
            "iron": "1gm",
          },
          "waterCount": 4,
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
          '',
          0));
      _startAutoRejectTimer();
      _startCountdownTimer();
      _scheduleMealNotifications(statusData);
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

      // Use the extracted use case to handle the meal acceptance logic
      await acceptMealUseCase.execute(state.statusData[state.currentMealIndex]);

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
          state.remainingTime));

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
            state.remainingTime));
      }
      _startCountdownTimer();
    });

    on<RejectMealEvent>((event, emit) {
      final state = this.state as MealPlanLoaded;
      final newState = rejectMealUseCase.rejectMeal(state);
      emit(newState);
      _startCountdownTimer();
    });

    on<ShowMealDescriptionEvent>((event, emit) async {
      final state = this.state as MealPlanLoaded;

      if (state.currentMealIndex == 3 && state.rejectedMeals[3]) {
        emit(MealPlanLoaded(
            state.statusData,
            state.acceptedMeals,
            state.rejectedMeals,
            state.currentMealIndex,
            false,
            state.currentMealIndex,
            -1,
            0,
            state.updateMessage,
            state.remainingTime));
        _startCountdownTimer();
      } else {
        bool showAcceptButton = event.mealIndex == state.currentMealIndex;
        final totalButtonPresses =
            state.acceptedMeals.where((meal) => meal).length +
                state.rejectedMeals.where((meal) => meal).length;
        if (state.currentMealIndex == 3 && totalButtonPresses >= 4) {
          showAcceptButton = false;
        }
        _showButtonTimer?.cancel();

        if (!showAcceptButton) {
          _showButtonTimer = Timer(const Duration(seconds: 5), () {
            add(ShowMealDescriptionEvent(state.currentMealIndex));
          });
        }

        emit(MealPlanLoaded(
            state.statusData,
            state.acceptedMeals,
            state.rejectedMeals,
            state.currentMealIndex,
            showAcceptButton,
            event.mealIndex,
            state.selectedBottleIndex,
            state.waterIntake,
            state.updateMessage,
            state.remainingTime));
      }
      _startCountdownTimer(event.mealIndex);
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
          state.updateMessage,
          state.remainingTime));

      await _recordWaterIntake(newWaterIntake);
    });

    on<UpdateCountdownEvent>((event, emit) {
      final state = this.state as MealPlanLoaded;
      emit(MealPlanLoaded(
        state.statusData,
        state.acceptedMeals,
        state.rejectedMeals,
        state.currentMealIndex,
        state.showAcceptButton,
        state.selectedMealIndex,
        state.selectedBottleIndex,
        state.waterIntake,
        state.updateMessage,
        event.remainingTime,
      ));
    });
  }

  void _scheduleMealNotifications(List<Map<String, dynamic>> statusData) {
    final now = DateTime.now();
    final mealTimes = [
      DateTime(now.year, now.month, now.day, 8, 30),
      DateTime(now.year, now.month, now.day, 12, 30),
      DateTime(now.year, now.month, now.day, 16, 30),
      DateTime(now.year, now.month, now.day, 20, 30),
    ];

    for (int i = 0; i < mealTimes.length; i++) {
      final mealTime = mealTimes[i];
      final meal = statusData[i];

      if (mealTime.isAfter(now)) {
        NotificationHelper.scheduleMealNotification(
          id: i,
          title: 'Meal Time',
          body: ' ${meal['statusLabel']} time ends in 30 mins ',
          scheduledDate: mealTime,
        );
      }
    }
  }

  void _startCountdownTimer([int? mealIndex]) {
    _countdownTimer?.cancel();

    _countdownTimer = Timer.periodic(const Duration(seconds: 0), (timer) {
      final state = this.state as MealPlanLoaded;
      final now = DateTime.now();
      final currentIndex = mealIndex ?? state.currentMealIndex;
      final nextMealTime = _getNextMealTime(now, currentIndex);
      final remainingTime = nextMealTime.difference(now).inSeconds;
      add(UpdateCountdownEvent(remainingTime));
    });
  }

  DateTime _getNextMealTime(DateTime now, int mealIndex) {
    final mealTimes = [
      DateTime(now.year, now.month, now.day, 9),
      DateTime(now.year, now.month, now.day, 13),
      DateTime(now.year, now.month, now.day, 17),
      DateTime(now.year, now.month, now.day, 21),
    ];

    return mealTimes[mealIndex];
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
              now.hour >= 18 &&
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
    _countdownTimer?.cancel();
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
