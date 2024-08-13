import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health/health.dart';
import 'package:loginpage/auth/bloc/auth_bloc.dart';
import 'package:loginpage/calorie/bloc/calorie_bloc.dart';
import 'package:loginpage/calorie/bloc/calorie_event.dart';
import 'package:loginpage/mealplan/Screens/meal_screen.dart';
import 'package:loginpage/mealplan/Services/permission.dart';
import 'package:loginpage/mealplan/bloc/meal_bloc.dart';
import 'package:loginpage/mealplan/bloc/meal_event.dart';
import 'package:loginpage/sign_up/bloc/question_event.dart';
import 'package:loginpage/sign_up/bloc/questionn_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:loginpage/calorie/services/health_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Health().configure(useHealthConnectIfAvailable: true);
  await Permission.activityRecognition.request();
  await Permission.location.request();
  await HealthService().fetchWeeklyCalorieData();
  await NotificationHelper.initializeNotifications();
  await Permission.notification.request();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CalorieBloc>(
          create: (context) =>
              CalorieBloc(HealthService())..add(FetchWeeklyCalorieData()),
        ),
        BlocProvider(
          create: (_) => QuestionBloc()..add(LoadQuestions()),
        ),
        BlocProvider(
          create: (context) => AuthBloc(FirebaseAuth.instance),
        ),
        BlocProvider(
          create: (context) => MealBloc()..add(LoadStatusDataEvent()),
          child: const MealPlanScreen(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MealPlanScreen(),
      ),
    );
  }
}
