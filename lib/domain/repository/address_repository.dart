abstract class AddressRepository {
  Future<Map<String, dynamic>> create(Map<String, dynamic> address);
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions);
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update);
  Future<Map<String, dynamic>> delete(String id);
}
