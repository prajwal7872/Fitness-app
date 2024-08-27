import 'package:loginpage/features/accordion/data/datasources/userdetails_remote_data_sources.dart';
import 'package:loginpage/features/accordion/data/models/userdetails_model.dart';
import 'package:loginpage/features/accordion/domain/entites/userdetails.dart';
import 'package:loginpage/features/accordion/domain/repositories/userdetails_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> postUserData(User user) async {
    final userModel = UserModel.fromEntity(user);
    await remoteDataSource.postUserData(userModel);
  }
}
