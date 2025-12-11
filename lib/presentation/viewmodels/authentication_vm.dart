import 'package:flutter/material.dart';
import 'package:first_flutter/data/services/authentication_service.dart';
import 'package:first_flutter/data/models/user.dart';

class AuthenticationVM extends ChangeNotifier {
  final IAuthenticationService authService;

  AuthenticationVM({required this.authService});

  User? currentUser;
  bool isLoading = false;
  String? errorMessage;

  Future<void> login(String username, String password) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final user = await authService.validateLogin(username, password);

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
