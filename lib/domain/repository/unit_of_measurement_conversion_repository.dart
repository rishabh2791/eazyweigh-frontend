abstract class UnitOfMeasurementConversionRepository {
  Future<Map<String, dynamic>> create(Map<String, dynamic> uomConversion);
  Future<Map<String, dynamic>> createMultiple(
      List<Map<String, dynamic>> uomConversion);
  Future<Map<String, dynamic>> get(String id);
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions);
}
