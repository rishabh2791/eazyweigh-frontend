import 'package:eazyweigh/domain/repository/shift_repository.dart';
import 'package:eazyweigh/infrastructure/network/network.dart';
import 'package:eazyweigh/infrastructure/utilities/enums/token_type.dart';

class ShiftRepo implements ShiftRepository {
  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> shift) async {
    String url = "shift/create/";
    var response =
        await networkAPIProvider.post(url, shift, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> get(String id) async {
    String url = "shift/" + id + "/";
    var response = await networkAPIProvider.get(url, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    String url = "shift/";
    var response =
        await networkAPIProvider.post(url, conditions, TokenType.accessToken);
    return response;
  }
}
