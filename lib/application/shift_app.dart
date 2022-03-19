import 'package:eazyweigh/domain/repository/shift_repository.dart';

class ShiftApp implements ShiftAppInterface {
  ShiftRepository shiftRepository;

  ShiftApp({
    required this.shiftRepository,
  });

  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> shift) async {
    return shiftRepository.create(shift);
  }

  @override
  Future<Map<String, dynamic>> get(String id) async {
    return shiftRepository.get(id);
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    return shiftRepository.list(conditions);
  }
}

abstract class ShiftAppInterface {
  Future<Map<String, dynamic>> create(Map<String, dynamic> shift);
  Future<Map<String, dynamic>> get(String id);
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions);
}
