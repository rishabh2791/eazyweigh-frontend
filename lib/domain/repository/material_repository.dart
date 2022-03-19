abstract class MaterialRepository {
  Future<Map<String, dynamic>> create(Map<String, dynamic> material);
  Future<Map<String, dynamic>> createMultiple(
      List<Map<String, dynamic>> materials);
  Future<Map<String, dynamic>> get(String id);
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions);
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update);
}
