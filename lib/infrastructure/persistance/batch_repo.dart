import 'package:eazyweigh/domain/repository/batch_repository.dart';
import 'package:eazyweigh/infrastructure/network/network.dart';
import 'package:eazyweigh/infrastructure/utilities/enums/token_type.dart';

class BatchRepo implements BatchRepository {
  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> batch) async {
    String url = "batch/create/";
    var response = await networkAPIProvider.post(url, batch, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> getBatch(String id) async {
    String url = "batch/" + id + "/";
    var response = await networkAPIProvider.get(url, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    String url = "batch/";
    var response = await networkAPIProvider.post(url, conditions, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update) async {
    String url = "batch/" + id + "/";
    var response = await networkAPIProvider.patch(url, update, TokenType.accessToken);
    return response;
  }
}
