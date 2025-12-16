
import 'package:flutter/material.dart';
import 'package:first_flutter/data/models/user.dart';
import 'package:first_flutter/data/repositories/authentication_repository.dart';

class AuthenticationVM extends ChangeNotifier {
  final IAuthenticationRepository authRepository;

  
  AuthenticationVM({required this.authRepository});

  User? currentUser;
  bool isLoading = false;
  String? errorMessage;

  Future<void> login(String username, String password) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();
      final user = await authRepository.validateLogin(username, password);

      currentUser = user;
    } catch (e) {
      errorMessage = e.toString().replaceAll("Exception:", "").trim();
      currentUser = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}