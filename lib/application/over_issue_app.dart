import 'package:eazyweigh/domain/repository/over_issue_repository.dart';

class OverIssueApp implements OverIssueAppInterface {
  OverIssueRepository overIssueRepository;

  OverIssueApp({required this.overIssueRepository});

  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> overIssue) async {
    return overIssueRepository.create(overIssue);
  }

  @override
  Future<Map<String, dynamic>> list(String jobID) async {
    return overIssueRepository.list(jobID);
  }

  @override
  Future<Map<String, dynamic>> update(
      String id, Map<String, dynamic> update) async {
    return overIssueRepository.update(id, update);
  }

  @override
  Future<Map<String, dynamic>> approve(String id) async {
    return overIssueRepository.approve(id);
  }

  @override
  Future<Map<String, dynamic>> reject(String id) async {
    return overIssueRepository.reject(id);
  }
}

abstract class OverIssueAppInterface {
  Future<Map<String, dynamic>> create(Map<String, dynamic> overIssue);
  Future<Map<String, dynamic>> list(String jobID);
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update);
  Future<Map<String, dynamic>> approve(String id);
  Future<Map<String, dynamic>> reject(String id);
}
