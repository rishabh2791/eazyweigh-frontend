abstract class UserCompanyRepository {
  Future<Map<String, dynamic>> create(Map<String, dynamic> userCompany);
  Future<Map<String, dynamic>> get(Map<String, dynamic> conditions);
}
