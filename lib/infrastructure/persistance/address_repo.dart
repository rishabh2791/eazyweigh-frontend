import 'package:eazyweigh/domain/repository/address_repository.dart';
import 'package:eazyweigh/infrastructure/network/network.dart';
import 'package:eazyweigh/infrastructure/utilities/enums/token_type.dart';
import 'package:eazyweigh/infrastructure/utilities/headers.dart';

class AddressRepo implements AddressRepository {
  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> address) async {
    String url = "address/create/";
    var response = await networkAPIProvider.post(
        url, address, getHeader(TokenType.accessToken));
    return response;
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    String url = "address/";
    var response = await networkAPIProvider.post(
        url, conditions, getHeader(TokenType.accessToken));
    return response;
  }

  @override
  Future<Map<String, dynamic>> update(
      String id, Map<String, dynamic> update) async {
    String url = "address/" + id + "/";
    var response = await networkAPIProvider.patch(
        url, update, getHeader(TokenType.accessToken));
    return response;
  }

  @override
  Future<Map<String, dynamic>> delete(String id) async {
    String url = "auth/" + id + "/";
    var response = await networkAPIProvider.delete(
        url, id, getHeader(TokenType.accessToken));
    return response;
  }
}
