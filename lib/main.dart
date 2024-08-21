import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/health.dart';
import 'package:loginpage/features/accordion/domain/usecases/get_question.dart';
import 'package:loginpage/features/accordion/domain/usecases/select_answer.dart';
import 'package:loginpage/features/accordion/domain/usecases/update_current_page_index.dart';
import 'package:loginpage/features/accordion/presentation/bloc/question_bloc.dart';
import 'package:loginpage/features/accordion/presentation/bloc/question_event.dart';
import 'package:loginpage/features/auth/Screens/auth_screen.dart';
import 'package:loginpage/features/calorie/bloc/calorie_bloc.dart';
import 'package:loginpage/features/calorie/bloc/calorie_event.dart';
import 'package:loginpage/features/mealplan/Services/permission.dart';
import 'package:loginpage/features/mealplan/bloc/meal_bloc.dart';
import 'package:loginpage/features/mealplan/bloc/meal_event.dart';
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

  final getQuestions = GetQuestions();
  final selectAnswer = SelectAnswer();
  final updateCurrentPageIndexusecase =
      UpdateCurrentPageIndexUseCase(selectAnswer);

  runApp(MyApp(
    getQuestions: getQuestions,
    selectAnswer: selectAnswer,
    updateCurrentPageIndexUseCase: updateCurrentPageIndexusecase,
  ));
}

class MyApp extends StatelessWidget {
  final GetQuestions getQuestions;
  final SelectAnswer selectAnswer;
  final UpdateCurrentPageIndexUseCase updateCurrentPageIndexUseCase;

  const MyApp({
    super.key,
    required this.getQuestions,
    required this.selectAnswer,
    required this.updateCurrentPageIndexUseCase,
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
              updateCurrentPageIndexUseCase: updateCurrentPageIndexUseCase)
            ..add(LoadQuestions()),
        ),
        BlocProvider(
          create: (context) => MealBloc()..add(LoadStatusDataEvent()),
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








// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:health/health.dart';
// import 'package:loginpage/accordion/domain/usecases/get_question.dart';
// import 'package:loginpage/accordion/presentation/bloc/question_bloc.dart';
// import 'package:loginpage/features/auth/Screens/auth_screen.dart';
// import 'package:loginpage/features/calorie/bloc/calorie_bloc.dart';
// import 'package:loginpage/features/calorie/bloc/calorie_event.dart';
// import 'package:loginpage/features/mealplan/Screens/meal_screen.dart';
// import 'package:loginpage/features/mealplan/Services/permission.dart';
// import 'package:loginpage/features/mealplan/bloc/meal_bloc.dart';
// import 'package:loginpage/features/mealplan/bloc/meal_event.dart';
// import 'package:loginpage/features/userdetails/bloc/userdetails_bloc.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:loginpage/features/calorie/services/health_service.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Health().configure(useHealthConnectIfAvailable: true);
//   await Permission.activityRecognition.request();
//   await Permission.location.request();
//   await HealthService().fetchWeeklyCalorieData();
//   await NotificationHelper.initializeNotifications();
//   await Permission.notification.request();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<CalorieBloc>(
//           create: (context) =>
//               CalorieBloc(HealthService())..add(FetchWeeklyCalorieData()),
//         ),
//         // BlocProvider(
//         //   create: (_) => QuestionBloc()..add(getQuestions()),
//         // ),
//          BlocProvider(
//           create: (_) => QuestionBloc(
//               getQuestions: getQuestions, selectAnswer: selectAnswer)
//             ..add(FetchQuestions()),
//         ),
//         BlocProvider(
//           create: (context) => MealBloc()..add(LoadStatusDataEvent()),
//           child: const MealPlanScreen(),
//         ),
//         BlocProvider(
//           create: (_) => UserDetailsBloc(),
//         )
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//         ),
//         home: const AuthScreen(),
//       ),
//     );
//   }
// }
