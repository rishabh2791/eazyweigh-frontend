import 'package:eazyweigh/domain/repository/job_item_repository.dart';

class JobItemApp implements JobItemAppInterface {
  JobItemRepository jobItemRepository;

  JobItemApp({
    required this.jobItemRepository,
  });

  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> job) async {
    return jobItemRepository.create(job);
  }

  @override
  Future<Map<String, dynamic>> createMultiple(
      List<Map<String, dynamic>> jobItems) async {
    return jobItemRepository.createMultiple(jobItems);
  }

  @override
  Future<Map<String, dynamic>> get(String jobID) async {
    return jobItemRepository.get(jobID);
  }

  @override
  Future<Map<String, dynamic>> update(
      String jobID, Map<String, dynamic> update) async {
    return jobItemRepository.update(jobID, update);
  }
}

abstract class JobItemAppInterface {
  Future<Map<String, dynamic>> create(Map<String, dynamic> job);
  Future<Map<String, dynamic>> createMultiple(
      List<Map<String, dynamic>> jobItems);
  Future<Map<String, dynamic>> get(String jobID);
  Future<Map<String, dynamic>> update(
      String jobID, Map<String, dynamic> update);
}
