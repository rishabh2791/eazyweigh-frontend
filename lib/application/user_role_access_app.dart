import 'package:eazyweigh/domain/repository/user_role_access_repository.dart';

class UserRoleAccessApp implements UserRoleAccessAppInterface {
  UserRoleAccessRepository userRoleAccessRepository;

  UserRoleAccessApp({
    required this.userRoleAccessRepository,
  });
}

abstract class UserRoleAccessAppInterface {}
