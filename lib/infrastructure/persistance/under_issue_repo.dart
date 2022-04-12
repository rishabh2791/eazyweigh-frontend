import 'package:eazyweigh/domain/repository/under_issue_repository.dart';
import 'package:eazyweigh/infrastructure/network/network.dart';
import 'package:eazyweigh/infrastructure/utilities/enums/token_type.dart';

class UnderIssueRepo implements UnderIssueRepository {
  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> underIssues) async {
    String url = "under_issue/create/";
    var response =
        await networkAPIProvider.post(url, underIssues, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> createMultiple(
      List<Map<String, dynamic>> underIssuess) async {
    String url = "under_issue/create/multi/";
    var response =
        await networkAPIProvider.post(url, underIssuess, TokenType.accessToken);
    return response;
  }

  @override
  Future<Map<String, dynamic>> list(String id) async {
    String url = "under_issue/" + id + "/";
    var response = await networkAPIProvider.get(url, TokenType.accessToken);
    return response;
  }
}
