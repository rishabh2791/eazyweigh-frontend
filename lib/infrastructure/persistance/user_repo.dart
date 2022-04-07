import 'package:eazyweigh/domain/repository/user_repository.dart';
import 'package:eazyweigh/infrastructure/network/network.dart';
import 'package:eazyweigh/infrastructure/utilities/enums/token_type.dart';

class UserRepo implements UserRepository {
  @override
  Future<Map<String, dynamic>> create(Map<String, String> user) async {
    String url = "user/create/";
    var response =
        await networkAPIProvider.post(url, user, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> createMultiple(
      List<Map<String, dynamic>> users) async {
    String url = "user/create/multi/";
    var response =
        await networkAPIProvider.post(url, users, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> getUser(String username) async {
    String url = "user/" + username + "/";
    var response = await networkAPIProvider.get(url, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> listUsers(
      Map<String, dynamic> conditions) async {
    String url = "user/";
    var response =
        await networkAPIProvider.post(url, conditions, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> update(
      String code, Map<String, dynamic> update) async {
    String url = "user/" + code + "/";
    var response =
        await networkAPIProvider.patch(url, update, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> activate(String code) async {
    String url = "user/" + code + "/";
    Map<String, dynamic> update = {
      "active": true,
    };
    var response =
        await networkAPIProvider.patch(url, update, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> deactivate(String code) async {
    String url = "user/" + code + "/";
    Map<String, dynamic> update = {
      "active": false,
    };
    var response =
        await networkAPIProvider.patch(url, update, TokenType.accessToken);
    return response;
  }
}
