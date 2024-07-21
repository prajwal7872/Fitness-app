// ignore_for_file: avoid_print

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'meal_event.dart';
part 'meal_state.dart';

class MealBloc extends Bloc<MealEvent, MealState> {
  MealBloc() : super(MealInitial()) {
    on<LoadStatusDataEvent>((event, emit) {
      final List<Map<String, dynamic>> statusData = [
        {
          "image": "assets/images/breakfast.jpeg",
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
          "mealDescription": "Snack Meal description",
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
      emit(MealPlanLoaded(statusData));
    });

    on<SelectMealEvent>((event, emit) {
      emit(MealSelected(
        event.selectedMeal,
        event.statusData,
      ));
    });
  }
}
