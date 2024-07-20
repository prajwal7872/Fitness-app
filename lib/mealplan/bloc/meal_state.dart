part of 'meal_bloc.dart';

sealed class MealState extends Equatable {
  const MealState();

  @override
  List<Object> get props => [];
}

final class MealInitial extends MealState {}

class MealPlanLoaded extends MealState {
  final List<Map<String, dynamic>> statusData;

  const MealPlanLoaded(
    this.statusData,
  );

  @override
  List<Object> get props => [statusData];
}

class MealSelected extends MealState {
  final List<Map<String, dynamic>> statusData;
  final Map<String, dynamic> selectedMeal;

  const MealSelected(
    this.selectedMeal,
    this.statusData,
  );

  @override
  List<Object> get props => [selectedMeal, statusData];
}
