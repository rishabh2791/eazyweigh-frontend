import 'package:eazyweigh/domain/repository/company_repository.dart';
import 'package:eazyweigh/infrastructure/network/network.dart';
import 'package:eazyweigh/infrastructure/utilities/enums/token_type.dart';

class CompanyRepo implements CompanyRepository {
  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> company) async {
    String url = "company/create/";
    var response = await networkAPIProvider.post(url, company, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> createMultiple(List<Map<String, dynamic>> companies) async {
    String url = "company/create/multi/";
    var response = await networkAPIProvider.post(url, companies, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> get(String id) async {
    String url = "company/" + id + "/";
    var response = await networkAPIProvider.get(url, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    String url = "company/";
    var response = await networkAPIProvider.post(url, conditions, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update) async {
    String url = "cimpany/" + id + "/";
    var response = await networkAPIProvider.patch(url, update, TokenType.accessToken);
    return response;
  }
}
