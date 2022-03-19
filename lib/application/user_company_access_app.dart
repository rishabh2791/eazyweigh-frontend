import 'package:eazyweigh/domain/repository/user_company_access_repository.dart';

class UserCompanyAccessApp implements UserCompanyAccessAppInterface {
  UserCompanyAccessRepository userCompanyAccessRepository;

  UserCompanyAccessApp({
    required this.userCompanyAccessRepository,
  });
}

abstract class UserCompanyAccessAppInterface {}
