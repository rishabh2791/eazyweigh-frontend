import 'package:eazyweigh/domain/repository/device_type_repository.dart';

class DeviceTypeApp implements DeviceTypeAppInterface {
  final DeviceTypeRepository deviceTypeRepository;

  DeviceTypeApp({required this.deviceTypeRepository});

  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> deviceType) {
    return deviceTypeRepository.create(deviceType);
  }

  @override
  Future<Map<String, dynamic>> createMultiple(List<Map<String, dynamic>> deviceTypes) {
    return deviceTypeRepository.createMultiple(deviceTypes);
  }

  @override
  Future<Map<String, dynamic>> getDevice(String id) {
    return deviceTypeRepository.getDevice(id);
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) {
    return deviceTypeRepository.list(conditions);
  }

  @override
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update) {
    return deviceTypeRepository.update(id, update);
  }
}

abstract class DeviceTypeAppInterface {
  Future<Map<String, dynamic>> create(Map<String, dynamic> deviceType);
  Future<Map<String, dynamic>> createMultiple(List<Map<String, dynamic>> deviceTypes);
  Future<Map<String, dynamic>> getDevice(String id);
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions);
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update);
}
