abstract class DeviceTypeRepository {
  Future<Map<String, dynamic>> create(Map<String, dynamic> deviceType);
  Future<Map<String, dynamic>> createMultiple(List<Map<String, dynamic>> deviceTypes);
  Future<Map<String, dynamic>> getDevice(String id);
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions);
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update);
}
