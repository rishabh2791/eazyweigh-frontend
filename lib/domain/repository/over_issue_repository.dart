abstract class OverIssueRepository {
  Future<Map<String, dynamic>> create(Map<String, dynamic> overIssue);
  Future<Map<String, dynamic>> createMultiple(
      List<Map<String, dynamic>> overIssues);
  Future<Map<String, dynamic>> list(String jobID);
  Future<Map<String, dynamic>> update(
      String overIssueID, Map<String, dynamic> update);
}
