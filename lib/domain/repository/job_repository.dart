abstract class JobRepository {
  Future<Map<String, dynamic>> create(Map<String, dynamic> job);
  Future<Map<String, dynamic>> createMultiple(List<Map<String, dynamic>> jobs);
  Future<Map<String, dynamic>> get(String id);
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions);
  Future<Map<String, dynamic>> update(
      String jobCode, Map<String, dynamic> update);
  Future<Map<String, dynamic>> pullFromRemote(String factoryID);
}
