import 'package:loginpage/features/accordion/data/model/user_details_mode.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class UserDetailsRemoteDataSource {
  Future<void> postUserDetails(UserDetails userDetails);
}

class UserDetailsRemoteDataSourceImpl implements UserDetailsRemoteDataSource {
  final http.Client client;

  UserDetailsRemoteDataSourceImpl({required this.client});

  @override
  Future<void> postUserDetails(UserDetails userDetails) async {
    final url = Uri.parse('http://192.168.101.124:8000/api/v1/user/signup');
    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userDetails.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to post user details');
    }
  }
}
