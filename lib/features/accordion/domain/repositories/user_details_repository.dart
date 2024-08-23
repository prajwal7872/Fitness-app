import 'package:loginpage/features/accordion/data/model/user_details_mode.dart';

abstract class UserDetailsRepository {
  Future<void> postUserDetails(UserDetails userDetails);
}
