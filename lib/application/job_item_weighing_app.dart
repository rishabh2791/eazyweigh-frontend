import 'package:eazyweigh/domain/repository/job_item_weighing_repository.dart';

class JobItemWeighingApp implements JobItemWeighingAppInterface {
  JobItemWeighingRepository jobItemWeighingRepository;

  JobItemWeighingApp({required this.jobItemWeighingRepository});

  @override
  Future<Map<String, dynamic>> create(
      Map<String, dynamic> jobItemWeighing) async {
    return jobItemWeighingRepository.create(jobItemWeighing);
  }
}

abstract class JobItemWeighingAppInterface {
  Future<Map<String, dynamic>> create(Map<String, dynamic> jobItemWeighing);
}
