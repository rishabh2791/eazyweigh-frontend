import 'package:eazyweigh/domain/repository/device_data_repository.dart';

class DeviceDataApp implements DeviceDataAppInterface {
  final DeviceDataRepository deviceDataRepository;

  DeviceDataApp({required this.deviceDataRepository});
  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> deviceData) async {
    return deviceDataRepository.create(deviceData);
  }

  @override
  Future<Map<String, dynamic>> get(String deviceID) async {
    return deviceDataRepository.get(deviceID);
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    return deviceDataRepository.list(conditions);
  }
}

abstract class DeviceDataAppInterface {
  Future<Map<String, dynamic>> create(Map<String, dynamic> deviceData);
  Future<Map<String, dynamic>> get(String deviceID);
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions);
}
