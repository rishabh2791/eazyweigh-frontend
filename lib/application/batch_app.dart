import 'package:eazyweigh/domain/repository/batch_repository.dart';

class BatchApp implements BatchAppInterface {
  final BatchRepository batchRepository;
  BatchApp({required this.batchRepository});

  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> batch) async {
    return batchRepository.create(batch);
  }

  @override
  Future<Map<String, dynamic>> getBatch(String id) async {
    return batchRepository.getBatch(id);
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    return batchRepository.list(conditions);
  }

  @override
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update) async {
    return batchRepository.update(id, update);
  }
}

abstract class BatchAppInterface {
  Future<Map<String, dynamic>> create(Map<String, dynamic> batch);
  Future<Map<String, dynamic>> getBatch(String id);
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions);
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update);
}
