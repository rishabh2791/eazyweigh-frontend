import 'package:eazyweigh/domain/repository/user_terminal_access_repository.dart';

class UserTerminalAccessApp implements UserTerminalAccessAppInterface {
  UserTerminalAccessRepository userTerminalAccessRepository;

  UserTerminalAccessApp({
    required this.userTerminalAccessRepository,
  });
}

abstract class UserTerminalAccessAppInterface {}
