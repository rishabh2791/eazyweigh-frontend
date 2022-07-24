import 'package:eazyweigh/domain/repository/device_data_repository.dart';

class DeviceDataApp implements DeviceDataAppInterface {
  final DeviceDataRepository deviceDataRepository;

  DeviceDataApp({required this.deviceDataRepository});
  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> deviceData) async {
    return deviceDataRepository.create(deviceData);
  }

  @override
  Future<Map<String, dynamic>> getForDevice(String deviceID, Map<String, dynamic> conditions) async {
    return deviceDataRepository.getForDevice(deviceID, conditions);
  }
}

abstract class DeviceDataAppInterface {
  Future<Map<String, dynamic>> create(Map<String, dynamic> deviceData);
  Future<Map<String, dynamic>> getForDevice(String deviceID, Map<String, dynamic> conditions);
}
