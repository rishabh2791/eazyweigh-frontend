import 'package:eazyweigh/domain/repository/unit_of_measurement_repository.dart';

class UnitOfMeasurementApp implements UnitOfMeasurementAppInterface {
  UnitOfMeasurementRepository unitOfMeasurementRepository;

  UnitOfMeasurementApp({
    required this.unitOfMeasurementRepository,
  });
  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> uom) async {
    return unitOfMeasurementRepository.create(uom);
  }

  @override
  Future<Map<String, dynamic>> createMultiple(
      List<Map<String, dynamic>> uoms) async {
    return unitOfMeasurementRepository.createMultiple(uoms);
  }

  @override
  Future<Map<String, dynamic>> get(String id) async {
    return unitOfMeasurementRepository.get(id);
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    return unitOfMeasurementRepository.list(conditions);
  }

  @override
  Future<Map<String, dynamic>> update(
      String id, Map<String, dynamic> update) async {
    return unitOfMeasurementRepository.update(id, update);
  }
}

abstract class UnitOfMeasurementAppInterface {
  Future<Map<String, dynamic>> create(Map<String, dynamic> uom);
  Future<Map<String, dynamic>> createMultiple(List<Map<String, dynamic>> uoms);
  Future<Map<String, dynamic>> get(String id);
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions);
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update);
}
