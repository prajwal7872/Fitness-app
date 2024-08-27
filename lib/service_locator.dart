import 'package:get_it/get_it.dart';
import 'package:loginpage/features/accordion/data/datasources/userdetails_remote_data_sources.dart';
import 'package:loginpage/features/accordion/data/repositories/userdetails_repo_impl.dart';
import 'package:loginpage/features/accordion/domain/repositories/userdetails_repository.dart';

import 'package:loginpage/features/accordion/domain/usecases/post_userdetails.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.I;

Future<void> init() async {
  // ! Data Layer
  sl.registerFactory<UserRemoteDataSource>(
      () => UserRemoteDataSource(client: sl()));
  sl.registerFactory<UserRepository>(
      () => UserRepositoryImpl(remoteDataSource: sl()));

  // ! Domain Layer
  sl.registerFactory(() => PostUserDataUseCase(repository: sl()));

  // ! External
  sl.registerFactory(() => http.Client());
}
