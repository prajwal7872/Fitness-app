import 'package:equatable/equatable.dart';

abstract class CalorieEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchWeeklyCalorieData extends CalorieEvent {}
