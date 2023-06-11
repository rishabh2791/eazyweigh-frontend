import 'package:eazyweigh/domain/repository/material_repository.dart';
import 'package:eazyweigh/infrastructure/network/network.dart';
import 'package:eazyweigh/infrastructure/utilities/enums/token_type.dart';

class MaterialRepo implements MaterialRepository {
  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> material) async {
    String url = "material/create/";
    var response = await networkAPIProvider.post(url, material, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> createMultiple(List<Map<String, dynamic>> materials) async {
    String url = "material/create/multi/";
    var response = await networkAPIProvider.post(url, materials, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> get(String id) async {
    String url = "material/" + id + "/";
    var response = await networkAPIProvider.get(url, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    String url = "material/";
    var response = await networkAPIProvider.post(url, conditions, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update) async {
    String url = "material/" + id + "/";
    var response = await networkAPIProvider.patch(url, update, TokenType.accessToken);
    return response;
  }
}
