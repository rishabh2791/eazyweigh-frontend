import 'package:eazyweigh/domain/repository/under_issue_repository.dart';

class UnderIssueApp implements UnderIssueAppInterface {
  UnderIssueRepository underIssueRepository;

  UnderIssueApp({
    required this.underIssueRepository,
  });

  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> underIssue) async {
    return underIssueRepository.create(underIssue);
  }

  @override
  Future<Map<String, dynamic>> createMultiple(List<Map<String, dynamic>> underIssues) async {
    return underIssueRepository.createMultiple(underIssues);
  }

  @override
  Future<Map<String, dynamic>> list(String jobID) async {
    return underIssueRepository.list(jobID);
  }

  @override
  Future<Map<String, dynamic>> update(String underIssueID, Map<String, dynamic> update) async {
    return underIssueRepository.update(underIssueID, update);
  }
}

abstract class UnderIssueAppInterface {
  Future<Map<String, dynamic>> create(Map<String, dynamic> underIssue);
  Future<Map<String, dynamic>> createMultiple(List<Map<String, dynamic>> underIssues);
  Future<Map<String, dynamic>> list(String jobID);
  Future<Map<String, dynamic>> update(String underIssueID, Map<String, dynamic> update);
}
