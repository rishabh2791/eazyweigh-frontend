abstract class DeviceDataRepository {
  Future<Map<String, dynamic>> create(Map<String, dynamic> deviceData);
  Future<Map<String, dynamic>> getForDevice(String deviceID, Map<String, dynamic> conditions);
}
