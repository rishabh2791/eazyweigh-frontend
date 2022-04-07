import 'package:eazyweigh/domain/repository/user_factory_repository.dart';
import 'package:eazyweigh/infrastructure/network/network.dart';
import 'package:eazyweigh/infrastructure/utilities/enums/token_type.dart';

class UserFactoryRepo implements UserFactoryRepository {
  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> userfactory) async {
    String url = "user_factory/create/";
    var response =
        await networkAPIProvider.post(url, userfactory, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> get(Map<String, dynamic> conditions) async {
    String url = "user_factory/";
    var response =
        await networkAPIProvider.post(url, conditions, TokenType.accessToken);
    return response;
  }
}
