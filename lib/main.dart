import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/health.dart';
import 'package:loginpage/features/accordion/domain/usecases/get_question.dart';
import 'package:loginpage/features/accordion/domain/usecases/select_answer.dart';
import 'package:loginpage/features/accordion/domain/usecases/validate_pageanswer.dart';
import 'package:loginpage/features/accordion/presentation/bloc/question_bloc.dart';
import 'package:loginpage/features/accordion/presentation/bloc/question_event.dart';
import 'package:loginpage/features/auth/Screens/auth_screen.dart';
import 'package:loginpage/features/calorie/bloc/calorie_bloc.dart';
import 'package:loginpage/features/calorie/bloc/calorie_event.dart';
import 'package:loginpage/features/meal/domain/usecases/accept_meal.dart';
import 'package:loginpage/features/meal/domain/usecases/reject_meal.dart';
import 'package:loginpage/features/meal/presentation/bloc/meal_bloc.dart';
import 'package:loginpage/features/meal/presentation/bloc/meal_event.dart';
import 'package:loginpage/features/meal/presentation/services/permission.dart';
import 'package:loginpage/features/userdetails/bloc/userdetails_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:loginpage/features/calorie/services/health_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Health().configure(useHealthConnectIfAvailable: true);
  await Permission.activityRecognition.request();
  await Permission.location.request();
  await HealthService().fetchWeeklyCalorieData();
  await NotificationHelper.initializeNotifications();
  await Permission.notification.request();
  final health = Health();
  final getQuestions = GetQuestions();
  final selectAnswer = SelectAnswer();
  final validatePageAnswers = ValidatePageAnswers(selectAnswer);
  final acceptMealUseCase = AcceptMealUseCase(health);
  final rejectMealUseCase = RejectMealUseCase();

  runApp(MyAppp(
    getQuestions: getQuestions,
    selectAnswer: selectAnswer,
    validatePageAnswers: validatePageAnswers,
    acceptMealUseCase: acceptMealUseCase,
    rejectMealUseCase: rejectMealUseCase,
  ));
}

class MyAppp extends StatelessWidget {
  final GetQuestions getQuestions;
  final SelectAnswer selectAnswer;
  final ValidatePageAnswers validatePageAnswers;
  final AcceptMealUseCase acceptMealUseCase;
  final RejectMealUseCase rejectMealUseCase;

  const MyAppp({
    super.key,
    required this.getQuestions,
    required this.selectAnswer,
    required this.validatePageAnswers,
    required this.acceptMealUseCase,
    required this.rejectMealUseCase,
  });

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
              getQuestions: getQuestions,
              selectAnswer: selectAnswer,
              validatePageAnswers: validatePageAnswers)
            ..add(LoadQuestions()),
        ),
        BlocProvider(
          create: (context) => MealBloc(
            acceptMealUseCase: acceptMealUseCase,
            rejectMealUseCase: rejectMealUseCase,
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
