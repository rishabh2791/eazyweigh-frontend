import 'package:eazyweigh/domain/repository/factory_repository.dart';

class FactoryApp implements FactoryAppInterface {
  FactoryRepository factoryRepository;

  FactoryApp({
    required this.factoryRepository,
  });

  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> factory) async {
    return factoryRepository.create(factory);
  }

  @override
  Future<Map<String, dynamic>> createMultiple(List<Map<String, dynamic>> factories) async {
    return factoryRepository.createMultiple(factories);
  }

  @override
  Future<Map<String, dynamic>> get(String id) async {
    return factoryRepository.get(id);
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    return factoryRepository.list(conditions);
  }

  @override
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update) async {
    return factoryRepository.update(id, update);
  }
}

abstract class FactoryAppInterface {
  Future<Map<String, dynamic>> create(Map<String, dynamic> factory);
  Future<Map<String, dynamic>> createMultiple(List<Map<String, dynamic>> factories);
  Future<Map<String, dynamic>> get(String id);
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions);
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update);
}
