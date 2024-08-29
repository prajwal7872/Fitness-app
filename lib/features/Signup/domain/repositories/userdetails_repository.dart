import 'package:loginpage/features/Signup/domain/entites/userdetails.dart';

abstract class UserRepository {
  Future<void> postUserData(User user);
}
