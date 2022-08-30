import 'package:eazyweigh/domain/repository/process_repository.dart';
import 'package:eazyweigh/infrastructure/network/network.dart';
import 'package:eazyweigh/infrastructure/utilities/enums/token_type.dart';

class ProcessRepo implements ProcessRepository {
  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> process) async {
    String url = "process/create/";
    var response = await networkAPIProvider.post(url, process, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> getProcess(String materialID) async {
    String url = "process/" + materialID + "/";
    var response = await networkAPIProvider.get(url, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    String url = "process/";
    var response = await networkAPIProvider.post(url, conditions, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update) async {
    String url = "process/" + id + "/";
    var response = await networkAPIProvider.patch(url, update, TokenType.accessToken);
    return response;
  }
}
