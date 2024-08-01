import 'package:equatable/equatable.dart';

sealed class MealState extends Equatable {
  const MealState();

  @override
  List<Object> get props => [];
}

class MealInitial extends MealState {}

class MealPlanLoaded extends MealState {
  final List<Map<String, dynamic>> statusData;
  final List<bool> acceptedMeals;
  final List<bool> rejectedMeals;
  final int currentMealIndex;
  final bool showAcceptButton;
  final int selectedMealIndex;
  final int selectedBottleIndex;
  final int waterIntake;
  final String updateMessage;
  final int remainingTime;

  const MealPlanLoaded(
    this.statusData,
    this.acceptedMeals,
    this.rejectedMeals,
    this.currentMealIndex,
    this.showAcceptButton,
    this.selectedMealIndex,
    this.selectedBottleIndex,
    this.waterIntake,
    this.updateMessage,
    this.remainingTime,
  );

  @override
  List<Object> get props => [
        statusData,
        acceptedMeals,
        rejectedMeals,
        currentMealIndex,
        showAcceptButton,
        selectedMealIndex,
        selectedBottleIndex,
        waterIntake,
        updateMessage,
        remainingTime,
      ];
}
