import 'package:eazyweigh/domain/repository/bom_repository.dart';

class BOMApp implements BOMAppInterfce {
  BOMRepository bomRepository;

  BOMApp({
    required this.bomRepository,
  });

  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> bom) async {
    return bomRepository.create(bom);
  }

  @override
  Future<Map<String, dynamic>> createMultiple(
      List<Map<String, dynamic>> boms) async {
    return bomRepository.createMultiple(boms);
  }

  @override
  Future<Map<String, dynamic>> get(String id) async {
    return bomRepository.get(id);
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    return bomRepository.list(conditions);
  }

  @override
  Future<Map<String, dynamic>> update(
      String id, Map<String, dynamic> update) async {
    return bomRepository.update(id, update);
  }
}

abstract class BOMAppInterfce {
  Future<Map<String, dynamic>> create(Map<String, dynamic> bom);
  Future<Map<String, dynamic>> createMultiple(List<Map<String, dynamic>> boms);
  Future<Map<String, dynamic>> get(String id);
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions);
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update);
}
