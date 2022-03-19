import 'package:eazyweigh/domain/repository/user_factory_access_repository.dart';

class UserFactoryAccessApp implements UserFactoryAccessAppInterface {
  UserFactoryAccessRepository userFactoryAccessRepository;

  UserFactoryAccessApp({
    required this.userFactoryAccessRepository,
  });
}

abstract class UserFactoryAccessAppInterface {}
