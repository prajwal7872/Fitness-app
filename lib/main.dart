import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loginpage/features/accordion/domain/usecases/get_question.dart';
import 'package:loginpage/features/accordion/domain/usecases/post_userdetails.dart';
import 'package:loginpage/features/accordion/domain/usecases/select_answer.dart';
import 'package:loginpage/features/auth/Screens/auth_screen.dart';
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
import 'package:loginpage/service_locator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:health/health.dart';
import 'features/accordion/domain/usecases/validate_pageanswer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  await Health().configure(useHealthConnectIfAvailable: true);
  await Permission.activityRecognition.request();
  await Permission.location.request();
  await sl<HealthService>().fetchWeeklyCalorieData();
  await NotificationHelper.initializeNotifications();
  await Permission.notification.request();

  runApp(const MyAppp());
}

class MyAppp extends StatelessWidget {
  const MyAppp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CalorieBloc>(
          create: (context) =>
              CalorieBloc(HealthService())..add(FetchWeeklyCalorieData()),
        ),
        BlocProvider(
          create: (_) => QuestionBloc(
              getQuestions: sl<GetQuestions>(),
              selectAnswer: sl<SelectAnswer>(),
              validatePageAnswers: sl<ValidatePageAnswers>(),
              postUserDataUseCase: sl<PostUserDataUseCase>())
            ..add(LoadQuestions()),
        ),
        BlocProvider(
          create: (context) => MealBloc(
            acceptMealUseCase: sl<AcceptMealUseCase>(),
            rejectMealUseCase: sl<RejectMealUseCase>(),
          )..add(LoadStatusDataEvent()),
        ),
        BlocProvider(
          create: (_) => UserDetailsBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const AuthScreen(),
      ),
    );
  }
}
