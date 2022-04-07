import 'package:eazyweigh/domain/repository/bom_repository.dart';
import 'package:eazyweigh/infrastructure/network/network.dart';
import 'package:eazyweigh/infrastructure/utilities/enums/token_type.dart';

class BOMRepo implements BOMRepository {
  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> bom) async {
    String url = "bom/create/";
    var response =
        await networkAPIProvider.post(url, bom, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> createMultiple(
      List<Map<String, dynamic>> boms) async {
    String url = "bom/create/multi/";
    var response =
        await networkAPIProvider.post(url, boms, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> get(String id) async {
    String url = "bom/" + id + "/";
    var response = await networkAPIProvider.get(url, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    String url = "bom/";
    var response =
        await networkAPIProvider.post(url, conditions, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> update(
      String id, Map<String, dynamic> update) async {
    String url = "bom/" + id + "/";
    var response =
        await networkAPIProvider.patch(url, update, TokenType.accessToken);
    return response;
  }
}
