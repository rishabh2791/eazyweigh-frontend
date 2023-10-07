import 'package:eazyweigh/domain/repository/batch_run_repository.dart';

class BatchRunApp implements BatchRunAppInterface {
  final BatchRunRepository batchRunRepository;
  BatchRunApp({required this.batchRunRepository});

  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> batch) async {
    return batchRunRepository.create(batch);
  }

  @override
  Future<Map<String, dynamic>> createSuper(Map<String, dynamic> batch) async {
    return batchRunRepository.createSuper(batch);
  }

  @override
  Future<Map<String, dynamic>> getBatch(String id) async {
    return batchRunRepository.getBatch(id);
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    return batchRunRepository.list(conditions);
  }

  @override
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update) async {
    return batchRunRepository.update(id, update);
  }
}

abstract class BatchRunAppInterface {
  Future<Map<String, dynamic>> create(Map<String, dynamic> batch);
  Future<Map<String, dynamic>> createSuper(Map<String, dynamic> batch);
  Future<Map<String, dynamic>> getBatch(String id);
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions);
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update);
}
