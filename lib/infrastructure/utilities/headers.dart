import 'package:eazyweigh/infrastructure/utilities/enums/token_type.dart';
import 'package:eazyweigh/infrastructure/utilities/variables.dart';

Map<String, String> getHeader(TokenType tokenType) {
  String? token = tokenType == TokenType.accessToken
      ? storage?.getString("access_token")
      : storage?.getString("refresh_token");
  Map<String, String> header = {
    "Authorization": tokenType.toString() + " " + token.toString(),
  };
  return header;
}
