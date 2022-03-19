abstract class ShiftRepository {
  Future<Map<String, dynamic>> create(Map<String, dynamic> shift);
  Future<Map<String, dynamic>> createMultiple(
      List<Map<String, dynamic>> shifts);
  Future<Map<String, dynamic>> get(String id);
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions);
}
