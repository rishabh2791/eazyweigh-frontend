import 'package:eazyweigh/domain/repository/shift_schedule_repository.dart';
import 'package:eazyweigh/infrastructure/network/network.dart';
import 'package:eazyweigh/infrastructure/utilities/enums/token_type.dart';
import 'package:eazyweigh/infrastructure/utilities/headers.dart';

class ShiftScheduleRepo implements ShiftScheduleRepository {
  @override
  Future<Map<String, dynamic>> create(
      Map<String, dynamic> shiftSchedule) async {
    String url = "shift_schedule/create/";
    var response = await networkAPIProvider.post(
        url, shiftSchedule, getHeader(TokenType.accessToken));
    return response;
  }

  @override
  Future<Map<String, dynamic>> createMultiple(
      List<Map<String, dynamic>> shiftSchedules) async {
    String url = "shift_schedule/create/multi/";
    var response = await networkAPIProvider.post(
        url, shiftSchedules, getHeader(TokenType.accessToken));
    return response;
  }

  @override
  Future<Map<String, dynamic>> get(String id) async {
    String url = "shift_schedule/" + id + "/";
    var response =
        await networkAPIProvider.get(url, getHeader(TokenType.accessToken));
    return response;
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    String url = "shift_schedule/";
    var response = await networkAPIProvider.post(
        url, conditions, getHeader(TokenType.accessToken));
    return response;
  }

  @override
  Future<Map<String, dynamic>> update(
      String id, Map<String, dynamic> update) async {
    String url = "shift_schedule/" + id + "/";
    var response = await networkAPIProvider.patch(
        url, update, getHeader(TokenType.accessToken));
    return response;
  }
}
