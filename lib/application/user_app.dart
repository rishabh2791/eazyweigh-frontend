import 'package:eazyweigh/domain/repository/user_repository.dart';

class UserApp implements UserAppInterface {
  UserRepository userRepository;

  UserApp({
    required this.userRepository,
  });

  @override
  Future<Map<String, dynamic>> create(Map<String, String> user) async {
    return userRepository.create(user);
  }

  @override
  Future<Map<String, dynamic>> createMultiple(
      List<Map<String, dynamic>> users) async {
    return userRepository.createMultiple(users);
  }

  @override
  Future<Map<String, dynamic>> getUser(String username) async {
    return userRepository.getUser(username);
  }

  @override
  Future<Map<String, dynamic>> listUsers(
      Map<String, dynamic> conditions) async {
    return userRepository.listUsers(conditions);
  }

  @override
  Future<Map<String, dynamic>> update(
      String username, Map<String, dynamic> update) async {
    return userRepository.update(username, update);
  }

  @override
  Future<Map<String, dynamic>> activate(String username) async {
    return userRepository.activate(username);
  }

  @override
  Future<Map<String, dynamic>> deactivate(String username) async {
    return userRepository.deactivate(username);
  }
}

abstract class UserAppInterface {
  Future<Map<String, dynamic>> create(Map<String, String> user);
  Future<Map<String, dynamic>> createMultiple(List<Map<String, dynamic>> users);
  Future<Map<String, dynamic>> getUser(String username);
  Future<Map<String, dynamic>> listUsers(Map<String, dynamic> conditions);
  Future<Map<String, dynamic>> update(
      String username, Map<String, dynamic> update);
  Future<Map<String, dynamic>> activate(String username);
  Future<Map<String, dynamic>> deactivate(String username);
}
