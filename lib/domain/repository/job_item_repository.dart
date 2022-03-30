abstract class JobItemRepository {
  Future<Map<String, dynamic>> create(Map<String, dynamic> job);
  Future<Map<String, dynamic>> createMultiple(
      List<Map<String, dynamic>> jobItems);
  Future<Map<String, dynamic>> get(
      String jobID, Map<String, dynamic> conditions);
  Future<Map<String, dynamic>> update(
      String jobID, Map<String, dynamic> update);
}
