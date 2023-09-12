import 'package:eazyweigh/domain/repository/job_item_weighing_repository.dart';

class JobItemWeighingApp implements JobItemWeighingAppInterface {
  JobItemWeighingRepository jobItemWeighingRepository;

  JobItemWeighingApp({required this.jobItemWeighingRepository});

  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> jobItemWeighing) async {
    return jobItemWeighingRepository.create(jobItemWeighing);
  }

  @override
  Future<Map<String, dynamic>> list(String jobItemID) async {
    return jobItemWeighingRepository.list(jobItemID);
  }

  @override
  Future<Map<String, dynamic>> update(String jobItemWeighingID, Map<String, dynamic> update) async {
    return jobItemWeighingRepository.update(jobItemWeighingID, update);
  }

  @override
  Future<Map<String, dynamic>> details(Map<String, dynamic> conditions) async {
    return jobItemWeighingRepository.details(conditions);
  }

  @override
  Future<Map<String, dynamic>> materials(String matID) async {
    return jobItemWeighingRepository.materials(matID);
  }
}

abstract class JobItemWeighingAppInterface {
  Future<Map<String, dynamic>> create(Map<String, dynamic> jobItemWeighing);
  Future<Map<String, dynamic>> list(String jobItemID);
  Future<Map<String, dynamic>> update(String jobItemWeighingID, Map<String, dynamic> update);
  Future<Map<String, dynamic>> details(Map<String, dynamic> conditions);
  Future<Map<String, dynamic>> materials(String matID);
}
