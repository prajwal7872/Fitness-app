part of 'meal_bloc.dart';

sealed class MealState extends Equatable {
  const MealState();
  
  @override
  List<Object> get props => [];
}

final class MealInitial extends MealState {}
