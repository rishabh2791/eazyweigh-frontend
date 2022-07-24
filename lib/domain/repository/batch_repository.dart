abstract class BatchRepository {
  Future<Map<String, dynamic>> create(Map<String, dynamic> batch);
  Future<Map<String, dynamic>> getBatch(String id);
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions);
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update);
}
