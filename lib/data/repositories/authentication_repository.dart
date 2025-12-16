
import 'package:first_flutter/data/models/user.dart';
import 'package:first_flutter/data/services/authentication_service.dart';

abstract class IAuthenticationRepository {
  Future<User> validateLogin(String username, String password);
}

class AuthenticationRepository implements IAuthenticationRepository {
  final IAuthenticationService authService;

  AuthenticationRepository({required this.authService});

  @override
  Future<User> validateLogin(String username, String password) {
    
    return authService.validateLogin(username, password);
  }
}