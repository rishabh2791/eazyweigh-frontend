import 'package:eazyweigh/domain/repository/step_repository.dart';
import 'package:eazyweigh/infrastructure/network/network.dart';
import 'package:eazyweigh/infrastructure/utilities/enums/token_type.dart';

class StepRepo implements StepRepository {
  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> step) async {
    String url = "step/create/";
    var response = await networkAPIProvider.post(url, step, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> createMultiple(List<Map<String, dynamic>> steps) async {
    String url = "step/create/multi/";
    var response = await networkAPIProvider.post(url, steps, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> getStep(String id) async {
    String url = "step/" + id + "/";
    var response = await networkAPIProvider.get(url, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    String url = "step/";
    var response = await networkAPIProvider.post(url, conditions, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update) async {
    String url = "step/" + id + "/";
    var response = await networkAPIProvider.patch(url, update, TokenType.accessToken);
    return response;
  }
}
