abstract class CompanyRepository {
  Future<Map<String, dynamic>> create(Map<String, dynamic> company);
  Future<Map<String, dynamic>> createMultiple(
      List<Map<String, dynamic>> companies);
  Future<Map<String, dynamic>> get(String id);
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions);
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update);
}
