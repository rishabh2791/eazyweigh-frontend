import 'package:eazyweigh/domain/repository/shift_schedule_repository.dart';

class ShiftScheduleApp implements ShiftScheduleAppInterface {
  ShiftScheduleRepository shiftScheduleRepository;

  ShiftScheduleApp({
    required this.shiftScheduleRepository,
  });

  @override
  Future<Map<String, dynamic>> create(
      Map<String, dynamic> shiftSchedule) async {
    return shiftScheduleRepository.create(shiftSchedule);
  }

  @override
  Future<Map<String, dynamic>> createMultiple(
      List<Map<String, dynamic>> shiftSchedules) async {
    return shiftScheduleRepository.createMultiple(shiftSchedules);
  }

  @override
  Future<Map<String, dynamic>> get(String id) async {
    return shiftScheduleRepository.get(id);
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    return shiftScheduleRepository.list(conditions);
  }

  @override
  Future<Map<String, dynamic>> update(
      String id, Map<String, dynamic> update) async {
    return shiftScheduleRepository.update(id, update);
  }
}

abstract class ShiftScheduleAppInterface {
  Future<Map<String, dynamic>> create(Map<String, dynamic> shiftSchedule);
  Future<Map<String, dynamic>> createMultiple(
      List<Map<String, dynamic>> shiftSchedules);
  Future<Map<String, dynamic>> get(String id);
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions);
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update);
}
