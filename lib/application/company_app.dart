import 'package:eazyweigh/domain/repository/company_repository.dart';

class CompanyApp implements CompanyAppInterface {
  CompanyRepository companyRepository;

  CompanyApp({
    required this.companyRepository,
  });

  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> company) async {
    return companyRepository.create(company);
  }

  @override
  Future<Map<String, dynamic>> createMultiple(List<Map<String, dynamic>> companies) async {
    return companyRepository.createMultiple(companies);
  }

  @override
  Future<Map<String, dynamic>> get(String id) async {
    return companyRepository.get(id);
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    return companyRepository.list(conditions);
  }

  @override
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update) async {
    return companyRepository.update(id, update);
  }
}

abstract class CompanyAppInterface {
  Future<Map<String, dynamic>> create(Map<String, dynamic> company);
  Future<Map<String, dynamic>> createMultiple(List<Map<String, dynamic>> companies);
  Future<Map<String, dynamic>> get(String id);
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions);
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update);
}
