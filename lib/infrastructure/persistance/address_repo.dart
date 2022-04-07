import 'package:eazyweigh/domain/repository/address_repository.dart';
import 'package:eazyweigh/infrastructure/network/network.dart';
import 'package:eazyweigh/infrastructure/utilities/enums/token_type.dart';

class AddressRepo implements AddressRepository {
  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> address) async {
    String url = "address/create/";
    var response =
        await networkAPIProvider.post(url, address, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    String url = "address/";
    var response =
        await networkAPIProvider.post(url, conditions, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> update(
      String id, Map<String, dynamic> update) async {
    String url = "address/" + id + "/";
    var response =
        await networkAPIProvider.patch(url, update, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> delete(String id) async {
    String url = "auth/" + id + "/";
    var response =
        await networkAPIProvider.delete(url, id, TokenType.accessToken);
    return response;
  }
}
