import 'package:eazyweigh/domain/repository/job_repository.dart';
import 'package:eazyweigh/infrastructure/network/network.dart';
import 'package:eazyweigh/infrastructure/utilities/enums/token_type.dart';
import 'package:eazyweigh/infrastructure/utilities/headers.dart';

class JobRepo implements JobRepository {
  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> job) async {
    String url = "job/create/";
    var response = await networkAPIProvider.post(
        url, job, getHeader(TokenType.accessToken));
    return response;
  }

  @override
  Future<Map<String, dynamic>> createMultiple(
      List<Map<String, dynamic>> jobs) async {
    String url = "job/create/multi/";
    var response = await networkAPIProvider.post(
        url, jobs, getHeader(TokenType.accessToken));
    return response;
  }

  @override
  Future<Map<String, dynamic>> get(String id) async {
    String url = "job/" + id + "/";
    var response =
        await networkAPIProvider.get(url, getHeader(TokenType.accessToken));
    return response;
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    String url = "job/";
    var response = await networkAPIProvider.post(
        url, conditions, getHeader(TokenType.accessToken));
    return response;
  }

  @override
  Future<Map<String, dynamic>> update(
      String id, Map<String, dynamic> update) async {
    String url = "job/" + id + "/";
    var response = await networkAPIProvider.patch(
        url, update, getHeader(TokenType.accessToken));
    return response;
  }
}
