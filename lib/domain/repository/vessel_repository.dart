abstract class VesselRepository {
  Future<Map<String, dynamic>> create(Map<String, dynamic> vessel);
  Future<Map<String, dynamic>> createMultiple(List<Map<String, dynamic>> vessels);
  Future<Map<String, dynamic>> getVessel(String id);
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions);
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update);
}
