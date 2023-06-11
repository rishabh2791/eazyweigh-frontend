import 'package:eazyweigh/domain/repository/terminal_repository.dart';
import 'package:eazyweigh/infrastructure/network/network.dart';
import 'package:eazyweigh/infrastructure/utilities/enums/token_type.dart';

class TerminalRepo implements TerminalRepository {
  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> terminal) async {
    String url = "terminal/create/";
    var response = await networkAPIProvider.post(url, terminal, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> createMultiple(List<Map<String, dynamic>> terminals) async {
    String url = "terminal/create/multi/";
    var response = await networkAPIProvider.post(url, terminals, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> get(String id) async {
    String url = "terminal/" + id + "/";
    var response = await networkAPIProvider.get(url, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    String url = "terminal/";
    var response = await networkAPIProvider.post(url, conditions, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update) async {
    String url = "terminal/" + id + "/";
    var response = await networkAPIProvider.patch(url, update, TokenType.accessToken);
    return response;
  }
}
