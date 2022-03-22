import 'package:eazyweigh/domain/repository/user_factory_repository.dart';

class UserFactoryApp implements UserFactoryAppInterface {
  UserFactoryRepository userFactoryRepository;

  UserFactoryApp({
    required this.userFactoryRepository,
  });

  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> userFactory) async {
    return userFactoryRepository.create(userFactory);
  }

  @override
  Future<Map<String, dynamic>> get(Map<String, dynamic> conditions) async {
    return userFactoryRepository.get(conditions);
  }
}

abstract class UserFactoryAppInterface {
  Future<Map<String, dynamic>> create(Map<String, dynamic> userFactory);
  Future<Map<String, dynamic>> get(Map<String, dynamic> conditions);
}
