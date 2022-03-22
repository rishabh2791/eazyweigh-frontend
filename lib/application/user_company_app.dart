import 'package:eazyweigh/domain/repository/user_company_repository.dart';

class UserCompanyApp implements UserCompanyAppInterface {
  UserCompanyRepository userCompanyRepository;

  UserCompanyApp({
    required this.userCompanyRepository,
  });

  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> userCompany) async {
    return userCompanyRepository.create(userCompany);
  }

  @override
  Future<Map<String, dynamic>> get(Map<String, dynamic> conditions) async {
    return userCompanyRepository.get(conditions);
  }
}

abstract class UserCompanyAppInterface {
  Future<Map<String, dynamic>> create(Map<String, dynamic> userCompany);
  Future<Map<String, dynamic>> get(Map<String, dynamic> conditions);
}
