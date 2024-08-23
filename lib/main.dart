import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:loginpage/features/calorie/services/health_service.dart';
import 'package:loginpage/features/meal/presentation/services/permission.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dependency_injection.dart';
import 'features/auth/Screens/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Health().configure(useHealthConnectIfAvailable: true);
  await Permission.activityRecognition.request();
  await Permission.location.request();
  await HealthService().fetchWeeklyCalorieData();
  await NotificationHelper.initializeNotifications();
  await Permission.notification.request();
  await DependencyInjection.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthScreen(),
    );
  }
}
