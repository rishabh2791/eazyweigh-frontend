import 'package:eazyweigh/domain/repository/job_repository.dart';

class JobApp implements JobAppInterface {
  JobRepository jobRepository;

  JobApp({
    required this.jobRepository,
  });

  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> job) async {
    return jobRepository.create(job);
  }

  @override
  Future<Map<String, dynamic>> createMultiple(
      List<Map<String, dynamic>> jobs) async {
    return jobRepository.createMultiple(jobs);
  }

  @override
  Future<Map<String, dynamic>> get(String id) async {
    return jobRepository.get(id);
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    return jobRepository.list(conditions);
  }

  @override
  Future<Map<String, dynamic>> update(
      String id, Map<String, dynamic> update) async {
    return jobRepository.update(id, update);
  }

  @override
  Future<Map<String, dynamic>> pullFromRemote(String factoryID) async {
    return jobRepository.pullFromRemote(factoryID);
  }
}

abstract class JobAppInterface {
  Future<Map<String, dynamic>> create(Map<String, dynamic> job);
  Future<Map<String, dynamic>> createMultiple(List<Map<String, dynamic>> jobs);
  Future<Map<String, dynamic>> get(String id);
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions);
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update);
  Future<Map<String, dynamic>> pullFromRemote(String factoryID);
}
