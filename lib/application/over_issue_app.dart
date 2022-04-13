import 'package:eazyweigh/domain/repository/over_issue_repository.dart';

class OverIssueApp implements OverIssueAppInterface {
  OverIssueRepository overIssueRepository;

  OverIssueApp({required this.overIssueRepository});

  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> overIssue) async {
    return overIssueRepository.create(overIssue);
  }

  @override
  Future<Map<String, dynamic>> createMultiple(
      List<Map<String, dynamic>> overIssues) async {
    return overIssueRepository.createMultiple(overIssues);
  }

  @override
  Future<Map<String, dynamic>> list(String jobID) async {
    return overIssueRepository.list(jobID);
  }

  @override
  Future<Map<String, dynamic>> update(
      String overIssueID, Map<String, dynamic> update) async {
    return overIssueRepository.update(overIssueID, update);
  }
}

abstract class OverIssueAppInterface {
  Future<Map<String, dynamic>> create(Map<String, dynamic> overIssue);
  Future<Map<String, dynamic>> createMultiple(
      List<Map<String, dynamic>> overIssues);
  Future<Map<String, dynamic>> list(String jobID);
  Future<Map<String, dynamic>> update(
      String overIssueID, Map<String, dynamic> update);
}
