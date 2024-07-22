part of 'meal_bloc.dart';

sealed class MealState extends Equatable {
  const MealState();

  @override
  List<Object> get props => [];
}

final class MealInitial extends MealState {}

class MealPlanLoaded extends MealState {
  final List<Map<String, dynamic>> statusData;
  final List<bool> acceptedMeals;
  final int currentMealIndex;

  const MealPlanLoaded(
      this.statusData, this.acceptedMeals, this.currentMealIndex);

  @override
  List<Object> get props => [
        statusData,
        acceptedMeals,
        currentMealIndex,
      ];
}
