import 'package:eazyweigh/domain/repository/under_issue_repository.dart';
import 'package:eazyweigh/infrastructure/network/network.dart';
import 'package:eazyweigh/infrastructure/utilities/enums/token_type.dart';
import 'package:eazyweigh/infrastructure/utilities/headers.dart';

class UnderIssueRepo implements UnderIssueRepository {
  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> bom) async {
    String url = "under_issue/create/";
    var response = await networkAPIProvider.post(
        url, bom, getHeader(TokenType.accessToken));
    return response;
  }

  @override
  Future<Map<String, dynamic>> list(String id) async {
    String url = "under_issue/" + id + "/";
    var response =
        await networkAPIProvider.get(url, getHeader(TokenType.accessToken));
    return response;
  }

  @override
  Future<Map<String, dynamic>> update(
      String id, Map<String, dynamic> update) async {
    String url = "under_issue/" + id + "/";
    var response = await networkAPIProvider.patch(
        url, update, getHeader(TokenType.accessToken));
    return response;
  }

  @override
  Future<Map<String, dynamic>> approve(String id) async {
    String url = "under_issue/" + id + "/approve/";
    var response = await networkAPIProvider.patch(
        url, {}, getHeader(TokenType.accessToken));
    return response;
  }

  @override
  Future<Map<String, dynamic>> reject(String id) async {
    String url = "under_issue/" + id + "/reject/";
    var response = await networkAPIProvider.patch(
        url, {}, getHeader(TokenType.accessToken));
    return response;
  }
}
