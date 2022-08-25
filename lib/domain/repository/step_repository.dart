abstract class StepRepository {
  Future<Map<String, dynamic>> create(Map<String, dynamic> step);
  Future<Map<String, dynamic>> createMultiple(List<Map<String, dynamic>> steps);
  Future<Map<String, dynamic>> getStep(String id);
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions);
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update);
}
