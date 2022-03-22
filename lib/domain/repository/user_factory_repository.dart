abstract class UserFactoryRepository {
  Future<Map<String, dynamic>> create(Map<String, dynamic> userFactory);
  Future<Map<String, dynamic>> get(Map<String, dynamic> conditions);
}
