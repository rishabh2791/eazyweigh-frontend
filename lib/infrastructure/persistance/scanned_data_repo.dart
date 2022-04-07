import 'package:eazyweigh/domain/repository/scanned_data_repository.dart';
import 'package:eazyweigh/infrastructure/network/network.dart';
import 'package:eazyweigh/infrastructure/utilities/enums/token_type.dart';

class ScannedDataRepo implements ScannedDataRepository {
  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> scan) async {
    String url = "scan/create/";
    var response =
        await networkAPIProvider.post(url, scan, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> get(String id) async {
    String url = "scan/" + id + "/";
    var response = await networkAPIProvider.get(url, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    String url = "scan/";
    var response =
        await networkAPIProvider.post(url, conditions, TokenType.accessToken);
    return response;
  }
}
