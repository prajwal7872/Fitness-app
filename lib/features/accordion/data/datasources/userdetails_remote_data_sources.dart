import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:loginpage/features/accordion/data/models/userdetails_model.dart';

class UserRemoteDataSource {
  final http.Client client;

  UserRemoteDataSource({required this.client});

  Future<void> postUserData(UserModel userModel) async {
    print('remote pugo');
    final response = await client.post(
      Uri.parse('http://192.168.101.124:8000/api/v1/user/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userModel.toJson()),
    );

    if (response.statusCode == 200) {
      print('Data posted successfully');
    } else {
      throw Exception('Failed to post user data');
    }
  }
}
