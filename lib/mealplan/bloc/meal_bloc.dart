// ignore_for_file: avoid_print

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:loginpage/mealplan/bloc/meal_event.dart';
import 'package:loginpage/mealplan/bloc/meal_state.dart';

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
          "recipeLink": "https://flutter.dev"
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
          "recipeLink": "https://flutter.dev"
        }
      ];

      emit(MealPlanLoaded(
          statusData,
          List<bool>.filled(statusData.length, false),
          List<bool>.filled(statusData.length, false),
          0,
          true,
          0));
      _startAutoRejectTimer();
    });

    on<AcceptMealEvent>((event, emit) {
      final state = this.state as MealPlanLoaded;
      final acceptedMeals = List<bool>.from(state.acceptedMeals);
      if (state.currentMealIndex < acceptedMeals.length) {
        acceptedMeals[state.currentMealIndex] = true;
      }
      final nextMealIndex = state.currentMealIndex < state.statusData.length - 1
          ? state.currentMealIndex + 1
          : state.currentMealIndex;
      emit(MealPlanLoaded(state.statusData, acceptedMeals, state.rejectedMeals,
          nextMealIndex, true, nextMealIndex));

      if (state.currentMealIndex == 3) {
        emit(MealPlanLoaded(state.statusData, acceptedMeals,
            state.rejectedMeals, nextMealIndex, false, state.currentMealIndex));
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
      emit(MealPlanLoaded(state.statusData, state.acceptedMeals, rejectedMeals,
          nextMealIndex, true, nextMealIndex));

      if (state.currentMealIndex == 3) {
        emit(MealPlanLoaded(state.statusData, state.acceptedMeals,
            rejectedMeals, nextMealIndex, false, nextMealIndex));
      }
    });

    on<ShowMealDescriptionEvent>((event, emit) async {
      final state = this.state as MealPlanLoaded;
      print(' mealIndex = ${event.mealIndex}');
      print('currentMealIndex = ${state.currentMealIndex}');

      final showAcceptButton = event.mealIndex == state.currentMealIndex;
      print(showAcceptButton);

      emit(MealPlanLoaded(
          state.statusData,
          state.acceptedMeals,
          state.rejectedMeals,
          state.currentMealIndex,
          showAcceptButton,
          event.mealIndex));

      if (state.currentMealIndex != event.mealIndex) {
        await Future.delayed(const Duration(seconds: 5));
        emit(MealPlanLoaded(
            state.statusData,
            state.acceptedMeals,
            state.rejectedMeals,
            state.currentMealIndex,
            true,
            state.currentMealIndex));
      }
    });
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
              now.minute >= 13) {
            add(RejectMealEvent());
          } else if (currentMealData['statusLabel'] == 'Dinner' &&
              now.hour >= 20 &&
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
}
