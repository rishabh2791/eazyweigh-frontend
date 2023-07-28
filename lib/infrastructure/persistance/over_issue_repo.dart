import 'package:eazyweigh/domain/repository/over_issue_repository.dart';
import 'package:eazyweigh/infrastructure/network/network.dart';
import 'package:eazyweigh/infrastructure/utilities/enums/token_type.dart';

class OverIssueRepo implements OverIssueRepository {
  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> overIssue) async {
    String url = "over_issue/create/";
    var response = await networkAPIProvider.post(url, overIssue, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> createMultiple(List<Map<String, dynamic>> overIssues) async {
    String url = "over_issue/create/multi/";
    var response = await networkAPIProvider.post(url, overIssues, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    String url = "over_issue/";
    var response = await networkAPIProvider.post(url, conditions, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> update(String overIssueID, Map<String, dynamic> update) async {
    String url = "over_issue/" + overIssueID + "/";
    var response = await networkAPIProvider.patch(url, update, TokenType.accessToken);
    return response;
  }
}
