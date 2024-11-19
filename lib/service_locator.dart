import 'package:get_it/get_it.dart';
import 'package:loginpage/features/Signup/data/datasources/userdetails_remote_data_sources.dart';
import 'package:loginpage/features/Signup/data/repositories/userdetails_repo_impl.dart';
import 'package:loginpage/features/Signup/domain/repositories/userdetails_repository.dart';
import 'package:loginpage/features/Signup/domain/usecases/get_question.dart';
import 'package:loginpage/features/Signup/domain/usecases/post_userdetails.dart';
import 'package:loginpage/features/Signup/domain/usecases/select_answer.dart';
import 'package:loginpage/features/Signup/domain/usecases/validate_pageanswer.dart';

import 'package:loginpage/features/meal/domain/usecases/accept_meal.dart';
import 'package:loginpage/features/meal/domain/usecases/reject_meal.dart';
import 'package:loginpage/features/calorie/services/health_service.dart';
import 'package:http/http.dart' as http;
import 'package:health/health.dart';

final sl = GetIt.I; // sl == Service Locator

Future<void> init() async {
  // ! External dependencies
  sl.registerFactory(() => http.Client());
  sl.registerFactory(() => Health());
  sl.registerFactory(() => HealthService());

  // ! Data Layer
  sl.registerFactory<UserRemoteDataSource>(
      () => UserRemoteDataSource(client: sl()));
  sl.registerFactory<UserRepository>(
      () => UserRepositoryImpl(remoteDataSource: sl()));

  // ! Domain Layer
  sl.registerFactory(() => PostUserDataUseCase(repository: sl()));
  sl.registerFactory(() => GetQuestions());
  sl.registerFactory(() => SelectAnswer());
  sl.registerFactory(() => ValidatePageAnswers(sl()));
  sl.registerFactory(() => AcceptMealUseCase(sl()));
  sl.registerFactory(() => RejectMealUseCase());
}
