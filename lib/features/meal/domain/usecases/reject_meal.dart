import 'package:loginpage/features/meal/presentation/bloc/meal_state.dart';

class RejectMealUseCase {
  MealPlanLoaded rejectMeal(MealPlanLoaded state) {
    final rejectedMeals = List<bool>.from(state.rejectedMeals);

    if (state.currentMealIndex < rejectedMeals.length) {
      rejectedMeals[state.currentMealIndex] = true;
    }
    final nextMealIndex = state.currentMealIndex < state.statusData.length - 1
        ? state.currentMealIndex + 1
        : state.currentMealIndex;

    String updateMessage = '';

    return MealPlanLoaded(
      state.statusData,
      state.acceptedMeals,
      rejectedMeals,
      nextMealIndex,
      true,
      nextMealIndex,
      -1,
      0,
      updateMessage,
      state.remainingTime,
    );
  }
}
