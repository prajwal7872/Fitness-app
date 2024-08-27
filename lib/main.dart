import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/health.dart';
import 'package:loginpage/features/accordion/data/datasources/userdetails_remote_data_sources.dart';
import 'package:loginpage/features/accordion/data/repositories/userdetails_repo_impl.dart';
import 'package:loginpage/features/accordion/domain/usecases/get_question.dart';
import 'package:loginpage/features/accordion/domain/usecases/post_userdetails.dart';
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
import 'package:http/http.dart' as http;

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
  final httpClient = http.Client();
  final userRemoteDataSource = UserRemoteDataSource(client: httpClient);
  final userRepository =
      UserRepositoryImpl(remoteDataSource: userRemoteDataSource);

  final postUserDataUseCase = PostUserDataUseCase(repository: userRepository);

  runApp(MyAppp(
    getQuestions: getQuestions,
    selectAnswer: selectAnswer,
    validatePageAnswers: validatePageAnswers,
    acceptMealUseCase: acceptMealUseCase,
    rejectMealUseCase: rejectMealUseCase,
    postUserDataUseCase: postUserDataUseCase,
  ));
}

class MyAppp extends StatelessWidget {
  final GetQuestions getQuestions;
  final SelectAnswer selectAnswer;
  final ValidatePageAnswers validatePageAnswers;
  final AcceptMealUseCase acceptMealUseCase;
  final RejectMealUseCase rejectMealUseCase;
  final PostUserDataUseCase postUserDataUseCase;

  const MyAppp({
    super.key,
    required this.getQuestions,
    required this.selectAnswer,
    required this.validatePageAnswers,
    required this.acceptMealUseCase,
    required this.rejectMealUseCase,
    required this.postUserDataUseCase,
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
              validatePageAnswers: validatePageAnswers,
              postUserDataUseCase: postUserDataUseCase)
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
