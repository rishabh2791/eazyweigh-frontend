import 'package:eazyweigh/domain/repository/vessel_repository.dart';
import 'package:eazyweigh/infrastructure/network/network.dart';
import 'package:eazyweigh/infrastructure/utilities/enums/token_type.dart';

class VesselRepo implements VesselRepository {
  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> vessel) async {
    String url = "vessel/create/";
    var response = await networkAPIProvider.post(url, vessel, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> createMultiple(List<Map<String, dynamic>> vessels) async {
    String url = "vessel/create/multi/";
    var response = await networkAPIProvider.post(url, vessels, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> getVessel(String id) async {
    String url = "vessel/" + id + "/";
    var response = await networkAPIProvider.get(url, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    String url = "vessel/";
    var response = await networkAPIProvider.post(url, conditions, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update) async {
    String url = "vessel/" + id + "/";
    var response = await networkAPIProvider.patch(url, update, TokenType.accessToken);
    return response;
  }
}
