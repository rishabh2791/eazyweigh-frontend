import 'package:eazyweigh/domain/repository/job_item_weighing_repository.dart';
import 'package:eazyweigh/infrastructure/network/network.dart';
import 'package:eazyweigh/infrastructure/utilities/enums/token_type.dart';

class JobItemWeighingRepo implements JobItemWeighingRepository {
  @override
  Future<Map<String, dynamic>> create(
      Map<String, dynamic> jobItemWeighing) async {
    String url = "job_item_weight/create/";
    var response = await networkAPIProvider.post(
        url, jobItemWeighing, TokenType.accessToken);
    return response;
  }
}
