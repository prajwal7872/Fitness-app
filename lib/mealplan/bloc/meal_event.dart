part of 'meal_bloc.dart';

sealed class MealEvent extends Equatable {
  const MealEvent();

  @override
  List<Object> get props => [];
}

class LoadStatusDataEvent extends MealEvent {}

class AcceptMealEvent extends MealEvent {}
