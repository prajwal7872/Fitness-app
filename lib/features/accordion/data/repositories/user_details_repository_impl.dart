import 'package:loginpage/features/accordion/data/datasources/user_details_remote_data_source.dart';
import 'package:loginpage/features/accordion/data/model/user_details_mode.dart';
import 'package:loginpage/features/accordion/domain/repositories/user_details_repository.dart';

class UserDetailsRepositoryImpl implements UserDetailsRepository {
  final UserDetailsRemoteDataSource remoteDataSource;

  UserDetailsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> postUserDetails(UserDetails userDetails) async {
    await remoteDataSource.postUserDetails(userDetails);
  }
}
