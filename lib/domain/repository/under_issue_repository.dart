abstract class UnderIssueRepository {
  Future<Map<String, dynamic>> create(Map<String, dynamic> underIssue);
  Future<Map<String, dynamic>> list(String jobID);
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update);
  Future<Map<String, dynamic>> approve(String id);
  Future<Map<String, dynamic>> reject(String id);
}
