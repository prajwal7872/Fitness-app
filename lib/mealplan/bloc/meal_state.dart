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

  const MealPlanLoaded(
    this.statusData,
    this.acceptedMeals,
    this.rejectedMeals,
    this.currentMealIndex,
    this.showAcceptButton,
    this.selectedMealIndex,
  );

  @override
  List<Object> get props => [
        statusData,
        acceptedMeals,
        rejectedMeals,
        currentMealIndex,
        showAcceptButton,
        selectedMealIndex,
      ];
}
