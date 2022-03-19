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
  Future<Map<String, dynamic>> list(String jobID) async {
    return underIssueRepository.list(jobID);
  }

  @override
  Future<Map<String, dynamic>> update(
      String id, Map<String, dynamic> update) async {
    return underIssueRepository.update(id, update);
  }

  @override
  Future<Map<String, dynamic>> approve(String id) async {
    return underIssueRepository.approve(id);
  }

  @override
  Future<Map<String, dynamic>> reject(String id) async {
    return underIssueRepository.reject(id);
  }
}

abstract class UnderIssueAppInterface {
  Future<Map<String, dynamic>> create(Map<String, dynamic> underIssue);
  Future<Map<String, dynamic>> list(String jobID);
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update);
  Future<Map<String, dynamic>> approve(String id);
  Future<Map<String, dynamic>> reject(String id);
}
