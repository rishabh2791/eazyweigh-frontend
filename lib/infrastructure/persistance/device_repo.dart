import 'package:eazyweigh/domain/repository/device_repository.dart';
import 'package:eazyweigh/infrastructure/network/network.dart';
import 'package:eazyweigh/infrastructure/utilities/enums/token_type.dart';

class DeviceRepo implements DeviceRepository {
  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> device) async {
    String url = "device/create/";
    var response = await networkAPIProvider.post(url, device, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> createMultiple(List<Map<String, dynamic>> devices) async {
    String url = "device/create/multi/";
    var response = await networkAPIProvider.post(url, devices, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> getDevice(String id) async {
    String url = "device/" + id + "/";
    var response = await networkAPIProvider.get(url, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    String url = "device/";
    var response = await networkAPIProvider.post(url, conditions, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update) async {
    String url = "device/" + id + "/";
    var response = await networkAPIProvider.patch(url, update, TokenType.accessToken);
    return response;
  }
}
