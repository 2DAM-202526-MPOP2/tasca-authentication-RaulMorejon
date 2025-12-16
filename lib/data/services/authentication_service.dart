// lib/data/services/authentication_service.dart
import 'dart:convert';
import 'package:first_flutter/data/models/user.dart';
import 'package:http/http.dart' as http;

abstract class IAuthenticationService {
  Future<User> validateLogin(String username, String password);
}

class AuthenticationService implements IAuthenticationService {
  @override
  Future<User> validateLogin(String username, String password) async {
    final url = Uri.parse('https://dummyjson.com/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body)); 
    } else if (response.statusCode == 400 || response.statusCode == 401) {
      
      final errorResponse = jsonDecode(response.body);
      throw Exception(
          '${errorResponse['message']}'); 
    } else {
      throw Exception('Login error'); 
    }
  }
}