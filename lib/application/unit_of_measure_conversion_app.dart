import 'package:eazyweigh/domain/repository/unit_of_measurement_conversion_repository.dart';

class UnitOfMeasurementConversionApp
    implements UnitOfMeasurementConversionAppInterface {
  UnitOfMeasurementConversionRepository unitOfMeasurementConversionRepository;

  UnitOfMeasurementConversionApp({
    required this.unitOfMeasurementConversionRepository,
  });

  @override
  Future<Map<String, dynamic>> create(
      Map<String, dynamic> uomConversion) async {
    return unitOfMeasurementConversionRepository.create(uomConversion);
  }

  @override
  Future<Map<String, dynamic>> createMultiple(
      List<Map<String, dynamic>> uomConversion) async {
    return unitOfMeasurementConversionRepository.createMultiple(uomConversion);
  }

  @override
  Future<Map<String, dynamic>> get(String id) async {
    return unitOfMeasurementConversionRepository.get(id);
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    return unitOfMeasurementConversionRepository.list(conditions);
  }
}

abstract class UnitOfMeasurementConversionAppInterface {
  Future<Map<String, dynamic>> create(Map<String, dynamic> uomConversion);
  Future<Map<String, dynamic>> createMultiple(
      List<Map<String, dynamic>> uomConversion);
  Future<Map<String, dynamic>> get(String id);
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions);
}
