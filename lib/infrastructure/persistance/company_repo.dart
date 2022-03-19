import 'package:eazyweigh/domain/repository/company_repository.dart';
import 'package:eazyweigh/infrastructure/network/network.dart';
import 'package:eazyweigh/infrastructure/utilities/enums/token_type.dart';
import 'package:eazyweigh/infrastructure/utilities/headers.dart';

class CompanyRepo implements CompanyRepository {
  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> company) async {
    String url = "company/create/";
    var response = await networkAPIProvider.post(
        url, company, getHeader(TokenType.accessToken));
    return response;
  }

  @override
  Future<Map<String, dynamic>> createMultiple(
      List<Map<String, dynamic>> companies) async {
    String url = "company/create/multi/";
    var response = await networkAPIProvider.post(
        url, companies, getHeader(TokenType.accessToken));
    return response;
  }

  @override
  Future<Map<String, dynamic>> get(String id) async {
    String url = "company/" + id + "/";
    var response =
        await networkAPIProvider.get(url, getHeader(TokenType.accessToken));
    return response;
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    String url = "company/";
    var response = await networkAPIProvider.post(
        url, conditions, getHeader(TokenType.accessToken));
    return response;
  }

  @override
  Future<Map<String, dynamic>> update(
      String id, Map<String, dynamic> update) async {
    String url = "cimpany/" + id + "/";
    var response = await networkAPIProvider.patch(
        url, update, getHeader(TokenType.accessToken));
    return response;
  }
}
