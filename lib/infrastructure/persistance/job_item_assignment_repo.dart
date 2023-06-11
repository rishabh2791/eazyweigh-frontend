import 'package:eazyweigh/domain/repository/job_item_assignment_repository.dart';
import 'package:eazyweigh/infrastructure/network/network.dart';
import 'package:eazyweigh/infrastructure/utilities/enums/token_type.dart';

class JobItemAssignmentRepo implements JobItemAssignmentRepository {
  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> jobItemAssignment) async {
    String url = "job_item_assignment/create/";
    var response = await networkAPIProvider.post(url, jobItemAssignment, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> createMultiple(List<Map<String, dynamic>> jobItemAssignments) async {
    String url = "job_item_assignment/create/multi/";
    var response = await networkAPIProvider.post(url, jobItemAssignments, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> get(String id) async {
    String url = "job_item_assignment/" + id + "/";
    var response = await networkAPIProvider.get(url, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    String url = "job_item_assignment/";
    var response = await networkAPIProvider.post(url, conditions, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update) async {
    String url = "job_item_assignment/" + id + "/";
    var response = await networkAPIProvider.patch(url, update, TokenType.accessToken);
    return response;
  }
}
