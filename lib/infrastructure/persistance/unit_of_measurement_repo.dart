import 'package:eazyweigh/domain/repository/unit_of_measurement_repository.dart';
import 'package:eazyweigh/infrastructure/network/network.dart';
import 'package:eazyweigh/infrastructure/utilities/enums/token_type.dart';

class UnitOfMeasurementRepo implements UnitOfMeasurementRepository {
  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> uom) async {
    String url = "uom/create/";
    var response =
        await networkAPIProvider.post(url, uom, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> createMultiple(
      List<Map<String, dynamic>> uoms) async {
    String url = "uom/create/multi/";
    var response =
        await networkAPIProvider.post(url, uoms, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> get(String id) async {
    String url = "uom/" + id + "/";
    var response = await networkAPIProvider.get(url, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    String url = "uom/";
    var response =
        await networkAPIProvider.post(url, conditions, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> update(
      String id, Map<String, dynamic> update) async {
    String url = "uom/" + id + "/";
    var response =
        await networkAPIProvider.patch(url, update, TokenType.accessToken);
    return response;
  }
}
