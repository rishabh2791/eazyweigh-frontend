import 'package:eazyweigh/domain/repository/job_item_weighing_repository.dart';

class JobItemWeighingApp implements JobItemWeighingAppInterface {
  JobItemWeighingRepository jobItemWeighingRepository;

  JobItemWeighingApp({required this.jobItemWeighingRepository});

  @override
  Future<Map<String, dynamic>> create(
      Map<String, dynamic> jobItemWeighing) async {
    return jobItemWeighingRepository.create(jobItemWeighing);
  }

  @override
  Future<Map<String, dynamic>> list(String jobItemID) async {
    return jobItemWeighingRepository.list(jobItemID);
  }
}

abstract class JobItemWeighingAppInterface {
  Future<Map<String, dynamic>> create(Map<String, dynamic> jobItemWeighing);
  Future<Map<String, dynamic>> list(String jobItemID);
}
