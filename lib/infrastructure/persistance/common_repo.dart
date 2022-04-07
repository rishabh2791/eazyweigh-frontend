import 'package:eazyweigh/domain/repository/common_repository.dart';
import 'package:eazyweigh/infrastructure/network/network.dart';
import 'package:eazyweigh/infrastructure/utilities/enums/token_type.dart';
import 'package:eazyweigh/infrastructure/utilities/headers.dart';

class CommonRepo implements CommonRepository {
  @override
  Future<Map<String, dynamic>> getTables() async {
    String url = "common/tables/";
    var response =
        await networkAPIProvider.get(url, getHeader(TokenType.accessToken));
    return response;
  }
}
