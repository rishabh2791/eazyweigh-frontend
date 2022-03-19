import 'package:eazyweigh/domain/repository/user_role_repository.dart';

class UserRoleApp implements UserRoleAppInterface {
  UserRoleRepository userRoleRepository;

  UserRoleApp({
    required this.userRoleRepository,
  });

  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> userRole) async {
    return userRoleRepository.create(userRole);
  }

  @override
  Future<Map<String, dynamic>> createMultiple(
      List<Map<String, dynamic>> userRoles) async {
    return userRoleRepository.createMultiple(userRoles);
  }

  @override
  Future<Map<String, dynamic>> get(String id) async {
    return userRoleRepository.get(id);
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    return userRoleRepository.list(conditions);
  }

  @override
  Future<Map<String, dynamic>> update(
      String id, Map<String, dynamic> update) async {
    return userRoleRepository.update(id, update);
  }
}

abstract class UserRoleAppInterface {
  Future<Map<String, dynamic>> create(Map<String, dynamic> userRole);
  Future<Map<String, dynamic>> createMultiple(
      List<Map<String, dynamic>> userRoles);
  Future<Map<String, dynamic>> get(String id);
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions);
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update);
}
