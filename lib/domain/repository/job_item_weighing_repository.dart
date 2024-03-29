abstract class JobItemWeighingRepository {
  Future<Map<String, dynamic>> create(Map<String, dynamic> jobItemWeighing);
  Future<Map<String, dynamic>> list(String jobItemID);
  Future<Map<String, dynamic>> update(String jobItemWeighingID, Map<String, dynamic> update);
  Future<Map<String, dynamic>> details(Map<String, dynamic> conditions);
  Future<Map<String, dynamic>> materials(String matID);
}
