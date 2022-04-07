import 'package:eazyweigh/domain/repository/user_role_access_repository.dart';
import 'package:eazyweigh/infrastructure/network/network.dart';
import 'package:eazyweigh/infrastructure/utilities/enums/token_type.dart';
import 'package:eazyweigh/infrastructure/utilities/headers.dart';

class UserRoleAccessRepo implements UserRoleAccessRepository {
  @override
  Future<Map<String, dynamic>> create(
      Map<String, dynamic> userRoleAccess) async {
    String url = "user_role_access/create/";
    var response = await networkAPIProvider.post(
        url, userRoleAccess, getHeader(TokenType.accessToken));
    return response;
  }

  @override
  Future<Map<String, dynamic>> createMultiple(
      List<Map<String, dynamic>> userRoleAccess) async {
    String url = "user_role_access/create/multi/";
    var response = await networkAPIProvider.post(
        url, userRoleAccess, getHeader(TokenType.accessToken));
    return response;
  }

  @override
  Future<Map<String, dynamic>> list(String userRole) async {
    String url = "user_role_access/" + userRole + "/";
    var response =
        await networkAPIProvider.get(url, getHeader(TokenType.accessToken));
    return response;
  }

  @override
  Future<Map<String, dynamic>> update(
      String userRole, Map<String, dynamic> userRoleAccess) async {
    String url = "user_role_access/" + userRole + "/";
    var response = await networkAPIProvider.patch(
        url, userRoleAccess, getHeader(TokenType.accessToken));
    return response;
  }
}
