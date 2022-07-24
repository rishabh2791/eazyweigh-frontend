import 'package:eazyweigh/domain/repository/process_repository.dart';

class ProcessApp implements ProcessAppInterface {
  final ProcessRepository processRepository;

  ProcessApp({required this.processRepository});

  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> process) async {
    return processRepository.create(process);
  }

  @override
  Future<Map<String, dynamic>> getProcess(String materialID) async {
    return processRepository.getProcess(materialID);
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    return processRepository.list(conditions);
  }

  @override
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update) async {
    return processRepository.update(id, update);
  }
}

abstract class ProcessAppInterface {
  Future<Map<String, dynamic>> create(Map<String, dynamic> bom);
  Future<Map<String, dynamic>> getProcess(String materialID);
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions);
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update);
}
