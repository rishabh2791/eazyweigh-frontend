import 'package:eazyweigh/domain/repository/common_repository.dart';
import 'package:eazyweigh/infrastructure/network/network.dart';
import 'package:eazyweigh/infrastructure/utilities/enums/token_type.dart';

class CommonRepo implements CommonRepository {
  @override
  Future<Map<String, dynamic>> getTables() async {
    String url = "common/tables/";
    var response = await networkAPIProvider.get(url, TokenType.accessToken);
    return response;
  }
}
