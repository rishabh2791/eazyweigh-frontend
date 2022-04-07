abstract class UserRepository {
  Future<Map<String, dynamic>> create(Map<String, String> user);
  Future<Map<String, dynamic>> createMultiple(List<Map<String, dynamic>> users);
  Future<Map<String, dynamic>> getUser(String username);
  Future<Map<String, dynamic>> listUsers(Map<String, dynamic> conditions);
  Future<Map<String, dynamic>> update(
      String username, Map<String, dynamic> update);
  Future<Map<String, dynamic>> activate(String username);
  Future<Map<String, dynamic>> deactivate(String username);
}
