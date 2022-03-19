import 'package:eazyweigh/domain/repository/material_repository.dart';

class MaterialApp implements MaterialAppInterface {
  MaterialRepository materialRepository;

  MaterialApp({
    required this.materialRepository,
  });

  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> material) async {
    return materialRepository.create(material);
  }

  @override
  Future<Map<String, dynamic>> createMultiple(
      List<Map<String, dynamic>> materials) async {
    return materialRepository.createMultiple(materials);
  }

  @override
  Future<Map<String, dynamic>> get(String id) async {
    return materialRepository.get(id);
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    return materialRepository.list(conditions);
  }

  @override
  Future<Map<String, dynamic>> update(
      String id, Map<String, dynamic> update) async {
    return materialRepository.update(id, update);
  }
}

abstract class MaterialAppInterface {
  Future<Map<String, dynamic>> create(Map<String, dynamic> material);
  Future<Map<String, dynamic>> createMultiple(
      List<Map<String, dynamic>> materials);
  Future<Map<String, dynamic>> get(String id);
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions);
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update);
}
