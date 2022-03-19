import 'package:eazyweigh/domain/repository/unit_of_measurement_conversion_repository.dart';
import 'package:eazyweigh/infrastructure/network/network.dart';
import 'package:eazyweigh/infrastructure/utilities/enums/token_type.dart';
import 'package:eazyweigh/infrastructure/utilities/headers.dart';

class UnitOfMeasurementConversionRepo
    implements UnitOfMeasurementConversionRepository {
  @override
  Future<Map<String, dynamic>> create(
      Map<String, dynamic> uomConversion) async {
    String url = "uom_conversion/create/";
    var response = await networkAPIProvider.post(
        url, uomConversion, getHeader(TokenType.accessToken));
    return response;
  }

  @override
  Future<Map<String, dynamic>> createMultiple(
      List<Map<String, dynamic>> uomConversions) async {
    String url = "uom_conversion/create/multi/";
    var response = await networkAPIProvider.post(
        url, uomConversions, getHeader(TokenType.accessToken));
    return response;
  }

  @override
  Future<Map<String, dynamic>> get(String id) async {
    String url = "uom_conversion/" + id + "/";
    var response =
        await networkAPIProvider.get(url, getHeader(TokenType.accessToken));
    return response;
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    String url = "uom_conversion/";
    var response = await networkAPIProvider.post(
        url, conditions, getHeader(TokenType.accessToken));
    return response;
  }
}
