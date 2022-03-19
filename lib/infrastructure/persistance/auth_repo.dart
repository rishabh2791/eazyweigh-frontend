import 'package:eazyweigh/domain/repository/auth_repository.dart';
import 'package:eazyweigh/infrastructure/network/network.dart';

class AuthRepo implements AuthRepository {
  @override
  Future<Map<String, dynamic>> login(Map<String, dynamic> loginDetails) async {
    String url = "auth/login/";
    var response = await networkAPIProvider.post(url, loginDetails, {});
    return response;
  }

  @override
  Future<Map<String, dynamic>> logout(Map<String, String> headers) async {
    String url = "auth/logout/";
    var response = await networkAPIProvider.post(url, {}, headers);
    return response;
  }

  @override
  Future<Map<String, dynamic>> refresh(Map<String, String> headers) async {
    String url = "auth/refresh/";
    var response = await networkAPIProvider.get(url, headers);
    return response;
  }

  @override
  Future<Map<String, dynamic>> resetPassword(
      Map<String, dynamic> passwordDetails, Map<String, String> headers) async {
    String url = "auth/reset/password/";
    var response = await networkAPIProvider.post(url, passwordDetails, headers);
    return response;
  }
}
