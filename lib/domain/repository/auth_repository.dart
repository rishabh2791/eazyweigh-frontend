abstract class AuthRepository {
  Future<Map<String, dynamic>> login(Map<String, dynamic> loginDetails);
  Future<Map<String, dynamic>> logout(Map<String, String> headers);
  Future<Map<String, dynamic>> refresh(Map<String, String> headers);
  Future<Map<String, dynamic>> resetPassword(
      Map<String, dynamic> passwordDetails, Map<String, String> headers);
}
