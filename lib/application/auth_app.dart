import 'package:eazyweigh/domain/repository/auth_repository.dart';

class AuthApp implements AuthAppInterface {
  AuthRepository authRepository;

  AuthApp({
    required this.authRepository,
  });

  @override
  Future<Map<String, dynamic>> login(Map<String, dynamic> loginDetails) async {
    return authRepository.login(loginDetails);
  }

  @override
  Future<Map<String, dynamic>> logout(Map<String, String> headers) async {
    return authRepository.logout(headers);
  }

  @override
  Future<Map<String, dynamic>> refresh(Map<String, String> headers) async {
    return authRepository.refresh(headers);
  }

  @override
  Future<Map<String, dynamic>> resetPassword(
      Map<String, dynamic> passwordDetails, Map<String, String> headers) async {
    return authRepository.resetPassword(passwordDetails, headers);
  }
}

abstract class AuthAppInterface {
  Future<Map<String, dynamic>> login(Map<String, dynamic> loginDetails);
  Future<Map<String, dynamic>> logout(Map<String, String> headers);
  Future<Map<String, dynamic>> refresh(Map<String, String> headers);
  Future<Map<String, dynamic>> resetPassword(
      Map<String, dynamic> passwordDetails, Map<String, String> headers);
}
