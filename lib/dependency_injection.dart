import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/health.dart';
import 'package:http/http.dart' as http;
import 'package:loginpage/features/accordion/data/datasources/user_details_remote_data_source.dart';
import 'package:loginpage/features/accordion/data/repositories/user_details_repository_impl.dart';
import 'package:loginpage/features/accordion/domain/usecases/get_question.dart';
import 'package:loginpage/features/accordion/domain/usecases/post_user_details.dart';
import 'package:loginpage/features/accordion/domain/usecases/select_answer.dart';
import 'package:loginpage/features/accordion/domain/usecases/validate_pageanswer.dart';
import 'package:loginpage/features/accordion/presentation/bloc/question_bloc.dart';
import 'package:loginpage/features/accordion/presentation/bloc/question_event.dart';
import 'package:loginpage/features/calorie/bloc/calorie_bloc.dart';
import 'package:loginpage/features/calorie/bloc/calorie_event.dart';
import 'package:loginpage/features/calorie/services/health_service.dart';
import 'package:loginpage/features/meal/domain/usecases/accept_meal.dart';
import 'package:loginpage/features/meal/domain/usecases/reject_meal.dart';
import 'package:loginpage/features/meal/presentation/bloc/meal_bloc.dart';
import 'package:loginpage/features/meal/presentation/bloc/meal_event.dart';
import 'package:loginpage/features/meal/presentation/services/permission.dart';
import 'package:loginpage/features/userdetails/bloc/userdetails_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class DependencyInjection {
  static Future<void> init() async {
    await Health().configure(useHealthConnectIfAvailable: true);
    await Permission.activityRecognition.request();
    await Permission.location.request();
    await HealthService().fetchWeeklyCalorieData();
    await NotificationHelper.initializeNotifications();
    await Permission.notification.request();

    final httpClient = http.Client();
    final userDetailsRemoteDataSource =
        UserDetailsRemoteDataSourceImpl(client: httpClient);
    final userDetailsRepository = UserDetailsRepositoryImpl(
        remoteDataSource: userDetailsRemoteDataSource);
    final postUserDetails = PostUserDetails(userDetailsRepository);
    final health = Health();

    BlocProvider<CalorieBloc>(
      create: (context) =>
          CalorieBloc(HealthService())..add(FetchWeeklyCalorieData()),
    );
    BlocProvider<QuestionBloc>(
      create: (_) => QuestionBloc(
        getQuestions: GetQuestions(),
        selectAnswer: SelectAnswer(),
        validatePageAnswers: ValidatePageAnswers(SelectAnswer()),
        postUserDetails: postUserDetails,
      )..add(LoadQuestions()),
    );
    BlocProvider<MealBloc>(
      create: (context) => MealBloc(
        acceptMealUseCase: AcceptMealUseCase(health),
        rejectMealUseCase: RejectMealUseCase(),
      )..add(LoadStatusDataEvent()),
    );
    BlocProvider<UserDetailsBloc>(
      create: (_) => UserDetailsBloc(),
    );
  }
}
