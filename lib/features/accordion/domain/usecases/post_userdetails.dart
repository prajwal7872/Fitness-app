import 'package:loginpage/features/accordion/domain/entites/userdetails.dart';
import 'package:loginpage/features/accordion/domain/repositories/userdetails_repository.dart';

class PostUserDataUseCase {
  final UserRepository repository;

  PostUserDataUseCase({required this.repository});

  Future<void> call(User user) async {
    await repository.postUserData(user);
  }
}
