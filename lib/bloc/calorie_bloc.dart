import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/services/health_service.dart';
import 'calorie_event.dart';
import 'calorie_state.dart';

class CalorieBloc extends Bloc<CalorieEvent, CalorieState> {
  final HealthService _healthService;

  CalorieBloc(this._healthService) : super(CalorieInitial()) {
    on<FetchWeeklyCalorieData>((event, emit) async {
      emit(CalorieLoading());

      try {
        final data = await _healthService.fetchWeeklyCalorieData();
        emit(CalorieLoaded(data));
      } catch (error) {
        emit(CalorieError(error.toString()));
      }
    });
  }
}


