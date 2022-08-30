import 'package:eazyweigh/domain/repository/device_data_repository.dart';
import 'package:eazyweigh/infrastructure/network/network.dart';
import 'package:eazyweigh/infrastructure/utilities/enums/token_type.dart';

class DeviceDataRepo implements DeviceDataRepository {
  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> deviceData) async {
    String url = "device_data/create/";
    var response = await networkAPIProvider.post(url, deviceData, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> getForDevice(String deviceID, Map<String, dynamic> conditions) async {
    String url = "device_data/" + deviceID + "/";
    var response = await networkAPIProvider.post(url, conditions, TokenType.accessToken);
    return response;
  }
}
