part of 'meal_bloc.dart';

sealed class MealEvent extends Equatable {
  const MealEvent();

  @override
  List<Object> get props => [];
}

class LoadStatusDataEvent extends MealEvent {}

class SelectMealEvent extends MealEvent {
  final Map<String, dynamic> selectedMeal;
  final List<Map<String, dynamic>> statusData;

  const SelectMealEvent(this.selectedMeal, this.statusData);

  @override
  List<Object> get props => [selectedMeal, statusData];
}
