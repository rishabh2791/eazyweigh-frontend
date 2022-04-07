import 'package:eazyweigh/domain/repository/user_company_repository.dart';
import 'package:eazyweigh/infrastructure/network/network.dart';
import 'package:eazyweigh/infrastructure/utilities/enums/token_type.dart';

class UserCompanyRepo implements UserCompanyRepository {
  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> userCompany) async {
    String url = "user_company/create/";
    var response =
        await networkAPIProvider.post(url, userCompany, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> get(Map<String, dynamic> conditions) async {
    String url = "user_company/";
    var response =
        await networkAPIProvider.post(url, conditions, TokenType.accessToken);
    return response;
  }
}
