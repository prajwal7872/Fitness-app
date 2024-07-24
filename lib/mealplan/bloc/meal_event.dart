import 'package:equatable/equatable.dart';

sealed class MealEvent extends Equatable {
  const MealEvent();

  @override
  List<Object> get props => [];
}

class LoadStatusDataEvent extends MealEvent {}

class AcceptMealEvent extends MealEvent {}

class RejectMealEvent extends MealEvent {}

class ShowMealDescriptionEvent extends MealEvent {
  final int mealIndex;

  const ShowMealDescriptionEvent(this.mealIndex);

  @override
  List<Object> get props => [mealIndex];
}
