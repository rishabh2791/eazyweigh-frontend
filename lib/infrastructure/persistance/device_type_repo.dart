import 'package:eazyweigh/domain/repository/device_type_repository.dart';
import 'package:eazyweigh/infrastructure/network/network.dart';
import 'package:eazyweigh/infrastructure/utilities/enums/token_type.dart';

class DeviceTypeRepo implements DeviceTypeRepository {
  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> deviceType) async {
    String url = "device_type/create/";
    var response = await networkAPIProvider.post(url, deviceType, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> createMultiple(List<Map<String, dynamic>> deviceTypes) async {
    String url = "device_type/create/multi/";
    var response = await networkAPIProvider.post(url, deviceTypes, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> getDevice(String id) async {
    String url = "device_type/" + id + "/";
    var response = await networkAPIProvider.get(url, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    String url = "device_type/";
    var response = await networkAPIProvider.post(url, conditions, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update) async {
    String url = "device_type/" + id + "/";
    var response = await networkAPIProvider.patch(url, update, TokenType.accessToken);
    return response;
  }
}
