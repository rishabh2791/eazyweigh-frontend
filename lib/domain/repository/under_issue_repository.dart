abstract class UnderIssueRepository {
  Future<Map<String, dynamic>> create(Map<String, dynamic> underIssue);
  Future<Map<String, dynamic>> createMultiple(
      List<Map<String, dynamic>> underIssues);
  Future<Map<String, dynamic>> list(String jobID);
}
