import 'package:loginpage/features/accordion/domain/entites/userdetails.dart';

abstract class UserRepository {
  Future<void> postUserData(User user);
}
