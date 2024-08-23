import 'package:loginpage/features/accordion/data/model/user_details_mode.dart';
import 'package:loginpage/features/accordion/domain/repositories/user_details_repository.dart';

class PostUserDetails {
  final UserDetailsRepository repository;

  PostUserDetails(this.repository);

  Future<void> call(UserDetails userDetails) async {
    await repository.postUserDetails(userDetails);
  }
}
