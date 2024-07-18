import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health/health.dart';
import 'package:loginpage/auth/Screens/auth_screen.dart';
import 'package:loginpage/auth/bloc/auth_bloc.dart';
import 'package:loginpage/calorie/bloc/calorie_bloc.dart';
import 'package:loginpage/calorie/bloc/calorie_event.dart';
import 'package:loginpage/calorie/bloc/calorie_state.dart';
import 'package:loginpage/calorie/screens/caloriechart_screen.dart';
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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return const AuthScreen();
          } else if (user.emailVerified) {
            return BlocBuilder<CalorieBloc, CalorieState>(
                builder: (context, state) {
              if (state is CalorieLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CalorieLoaded) {
                return CalorieChart(state.weeklyCalorieData);
              } else if (state is CalorieError) {
                return Center(child: Text(state.message));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            });
          } else {
            return const AuthScreen();
          }
        }

        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
