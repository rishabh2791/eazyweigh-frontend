import 'package:eazyweigh/domain/repository/step_type_repository.dart';
import 'package:eazyweigh/infrastructure/network/network.dart';
import 'package:eazyweigh/infrastructure/utilities/enums/token_type.dart';

class StepTypeRepo implements StepTypeRepository {
  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> stepType) async {
    String url = "step_type/create/";
    var response = await networkAPIProvider.post(url, stepType, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> createMultiple(List<Map<String, dynamic>> stepTypes) async {
    String url = "step_type/create/multi/";
    var response = await networkAPIProvider.post(url, stepTypes, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> getStepType(String id) async {
    String url = "step_type/" + id + "/";
    var response = await networkAPIProvider.get(url, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    String url = "step_type/";
    var response = await networkAPIProvider.post(url, conditions, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update) async {
    String url = "step_type/" + id + "/";
    var response = await networkAPIProvider.patch(url, update, TokenType.accessToken);
    return response;
  }
}
