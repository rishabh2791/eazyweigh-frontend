abstract class ProcessRepository {
  Future<Map<String, dynamic>> create(Map<String, dynamic> process);
  Future<Map<String, dynamic>> getProcess(String materialID);
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions);
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update);
}
