import 'package:eazyweigh/domain/repository/job_assignment_repository.dart';

class JobAssignmentApp implements JobAssignmentAppInterface {
  JobAssignmentRepository jobAssignmentRepository;

  JobAssignmentApp({
    required this.jobAssignmentRepository,
  });

  @override
  Future<Map<String, dynamic>> create(
      Map<String, dynamic> jobAssignment) async {
    return jobAssignmentRepository.create(jobAssignment);
  }

  @override
  Future<Map<String, dynamic>> createMultiple(
      List<Map<String, dynamic>> jobAssignments) async {
    return jobAssignmentRepository.createMultiple(jobAssignments);
  }

  @override
  Future<Map<String, dynamic>> get(String id) async {
    return jobAssignmentRepository.get(id);
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    return jobAssignmentRepository.list(conditions);
  }

  @override
  Future<Map<String, dynamic>> update(
      String id, Map<String, dynamic> update) async {
    return jobAssignmentRepository.update(id, update);
  }
}

abstract class JobAssignmentAppInterface {
  Future<Map<String, dynamic>> create(Map<String, dynamic> jobAssignment);
  Future<Map<String, dynamic>> createMultiple(
      List<Map<String, dynamic>> jobAssignments);
  Future<Map<String, dynamic>> get(String id);
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions);
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update);
}
