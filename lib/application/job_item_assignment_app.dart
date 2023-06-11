import 'package:eazyweigh/domain/repository/job_item_assignment_repository.dart';

class JobItemAssignmentApp implements JobItemAssignmentAppInterface {
  JobItemAssignmentRepository jobItemAssignmentRepository;

  JobItemAssignmentApp({
    required this.jobItemAssignmentRepository,
  });

  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> jobItemAssignment) async {
    return jobItemAssignmentRepository.create(jobItemAssignment);
  }

  @override
  Future<Map<String, dynamic>> createMultiple(List<Map<String, dynamic>> jobItemAssignments) async {
    return jobItemAssignmentRepository.createMultiple(jobItemAssignments);
  }

  @override
  Future<Map<String, dynamic>> get(String id) async {
    return jobItemAssignmentRepository.get(id);
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    return jobItemAssignmentRepository.list(conditions);
  }

  @override
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update) async {
    return jobItemAssignmentRepository.update(id, update);
  }
}

abstract class JobItemAssignmentAppInterface {
  Future<Map<String, dynamic>> create(Map<String, dynamic> jobItemAssignment);
  Future<Map<String, dynamic>> createMultiple(List<Map<String, dynamic>> jobItemAssignments);
  Future<Map<String, dynamic>> get(String id);
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions);
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update);
}
