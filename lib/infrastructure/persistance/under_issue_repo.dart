import 'package:eazyweigh/domain/repository/under_issue_repository.dart';
import 'package:eazyweigh/infrastructure/network/network.dart';
import 'package:eazyweigh/infrastructure/utilities/enums/token_type.dart';

class UnderIssueRepo implements UnderIssueRepository {
  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> underIssues) async {
    String url = "under_issue/create/";
    var response = await networkAPIProvider.post(url, underIssues, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> createMultiple(List<Map<String, dynamic>> underIssuess) async {
    String url = "under_issue/create/multi/";
    var response = await networkAPIProvider.post(url, underIssuess, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    String url = "under_issue";
    var response = await networkAPIProvider.post(url, conditions, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> update(String underIssueID, Map<String, dynamic> update) async {
    String url = "under_issue/" + underIssueID + "/";
    var response = await networkAPIProvider.patch(url, update, TokenType.accessToken);
    return response;
  }
}
