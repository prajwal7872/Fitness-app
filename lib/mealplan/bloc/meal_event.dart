import 'package:equatable/equatable.dart';

sealed class MealEvent extends Equatable {
  const MealEvent();

  @override
  List<Object> get props => [];
}

class LoadStatusDataEvent extends MealEvent {}

class AcceptMealEvent extends MealEvent {
  final int waterIntake;

  const AcceptMealEvent(this.waterIntake);

  @override
  List<Object> get props => [waterIntake];
}

class RejectMealEvent extends MealEvent {}

class ShowMealDescriptionEvent extends MealEvent {
  final int mealIndex;

  const ShowMealDescriptionEvent(this.mealIndex);

  @override
  List<Object> get props => [mealIndex];
}

class SelectBottleEvent extends MealEvent {
  final int bottleIndex;

  const SelectBottleEvent(this.bottleIndex);

  @override
  List<Object> get props => [bottleIndex];
}

class UpdateCountdownEvent extends MealEvent {
  final String remainingTime;

  const UpdateCountdownEvent(this.remainingTime);

  @override
  List<Object> get props => [remainingTime];
}
