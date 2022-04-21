abstract class JobItemWeighingRepository {
  Future<Map<String, dynamic>> create(Map<String, dynamic> jobItemWeighing);
  Future<Map<String, dynamic>> list(String jobItemID);
}
