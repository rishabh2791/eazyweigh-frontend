import 'package:eazyweigh/domain/repository/bom_item_repository.dart';
import 'package:eazyweigh/infrastructure/network/network.dart';
import 'package:eazyweigh/infrastructure/utilities/enums/token_type.dart';

class BOMItemRepo implements BOMItemRepository {
  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> bomItem) async {
    String url = "bom_item/create/";
    var response =
        await networkAPIProvider.post(url, bomItem, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> createMultiple(
      List<Map<String, dynamic>> bomItems) async {
    String url = "bom_item/create/multi/";
    var response =
        await networkAPIProvider.post(url, bomItems, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> get(String id) async {
    String url = "bom_item/" + id + "/";
    var response = await networkAPIProvider.get(url, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    String url = "bom_item/";
    var response =
        await networkAPIProvider.post(url, conditions, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> update(
      String id, Map<String, dynamic> update) async {
    String url = "bom_item/" + id + "/";
    var response =
        await networkAPIProvider.patch(url, update, TokenType.accessToken);
    return response;
  }
}
