import 'package:eazyweigh/domain/repository/batch_run_repository.dart';
import 'package:eazyweigh/infrastructure/network/network.dart';
import 'package:eazyweigh/infrastructure/utilities/enums/token_type.dart';

class BatchRunRepo implements BatchRunRepository {
  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> batch) async {
    String url = "batchrun/create/";
    var response = await networkAPIProvider.post(url, batch, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> getBatch(String id) async {
    String url = "batchrun/" + id + "/";
    var response = await networkAPIProvider.get(url, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    String url = "batchrun/";
    var response = await networkAPIProvider.post(url, conditions, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update) async {
    String url = "batchrun/" + id + "/";
    var response = await networkAPIProvider.patch(url, update, TokenType.accessToken);
    return response;
  }
}
