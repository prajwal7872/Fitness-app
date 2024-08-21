import 'package:equatable/equatable.dart';

class CalorieState extends Equatable {
  @override
  List<Object> get props => [];
}

class CalorieInitial extends CalorieState {}

class CalorieLoading extends CalorieState {}

class CalorieLoaded extends CalorieState {
  final Map<String, double> weeklyCalorieData;

  CalorieLoaded(this.weeklyCalorieData);

  @override
  List<Object> get props => [weeklyCalorieData];
}

class CalorieError extends CalorieState {
  final String message;

  CalorieError(this.message);

  @override
  List<Object> get props => [message];
}
