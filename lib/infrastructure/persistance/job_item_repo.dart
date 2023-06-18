import 'package:eazyweigh/domain/repository/job_item_repository.dart';
import 'package:eazyweigh/infrastructure/network/network.dart';
import 'package:eazyweigh/infrastructure/utilities/enums/token_type.dart';

class JobItemRepo implements JobItemRepository {
  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> jobItem) async {
    String url = "job_item/create/";
    var response = await networkAPIProvider.post(url, jobItem, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> createMultiple(List<Map<String, dynamic>> jobItems) async {
    String url = "job_item/create/multi/";
    var response = await networkAPIProvider.post(url, jobItems, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> get(Map<String, dynamic> conditions) async {
    String url = "job_item/";
    var response = await networkAPIProvider.post(url, conditions, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update) async {
    String url = "job_item/" + id + "/";
    var response = await networkAPIProvider.patch(url, update, TokenType.accessToken);
    return response;
  }
}
