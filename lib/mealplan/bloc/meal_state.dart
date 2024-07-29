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
      ];
}




    // on<ShowMealDescriptionEvent>((event, emit) async {
    //   final state = this.state as MealPlanLoaded;
    //   print(' mealIndex = ${event.mealIndex}');
    //   print('currentMealIndex = ${state.currentMealIndex}');

    //   final showAcceptButton = event.mealIndex == state.currentMealIndex;
    //   print(showAcceptButton);

    //   emit(MealPlanLoaded(
    //       state.statusData,
    //       state.acceptedMeals,
    //       state.rejectedMeals,
    //       state.currentMealIndex,
    //       showAcceptButton,
    //       event.mealIndex,
    //       -1,
    //       0));

    //   if (state.currentMealIndex != event.mealIndex) {
    //     await Future.delayed(const Duration(seconds: 5));
    //     emit(MealPlanLoaded(
    //         state.statusData,
    //         state.acceptedMeals,
    //         state.rejectedMeals,
    //         state.currentMealIndex,
    //         true,
    //         state.currentMealIndex,
    //         -1,
    //         0));
    //   }
    // });