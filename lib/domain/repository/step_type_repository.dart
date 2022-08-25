abstract class StepTypeRepository {
  Future<Map<String, dynamic>> create(Map<String, dynamic> stepType);
  Future<Map<String, dynamic>> createMultiple(List<Map<String, dynamic>> stepTypes);
  Future<Map<String, dynamic>> getStepType(String id);
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions);
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update);
}
