import 'package:eazyweigh/domain/repository/bom_item_repository.dart';

class BOMItemApp implements BOMItemAppInterface {
  BOMItemRepository bomItemRepository;

  BOMItemApp({
    required this.bomItemRepository,
  });

  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> bomItem) async {
    return bomItemRepository.create(bomItem);
  }

  @override
  Future<Map<String, dynamic>> createMultiple(
      List<Map<String, dynamic>> bomItems) async {
    return bomItemRepository.createMultiple(bomItems);
  }

  @override
  Future<Map<String, dynamic>> get(String id) async {
    return bomItemRepository.get(id);
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    return bomItemRepository.list(conditions);
  }

  @override
  Future<Map<String, dynamic>> update(
      String id, Map<String, dynamic> update) async {
    return bomItemRepository.update(id, update);
  }
}

abstract class BOMItemAppInterface {
  Future<Map<String, dynamic>> create(Map<String, dynamic> bomItem);
  Future<Map<String, dynamic>> createMultiple(
      List<Map<String, dynamic>> bomItems);
  Future<Map<String, dynamic>> get(String id);
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions);
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update);
}
