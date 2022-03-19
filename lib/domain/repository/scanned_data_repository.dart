abstract class ScannedDataRepository {
  Future<Map<String, dynamic>> create(Map<String, dynamic> scannedData);
  Future<Map<String, dynamic>> get(String id);
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions);
}
