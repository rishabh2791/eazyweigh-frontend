import 'package:eazyweigh/domain/repository/step_repository.dart';

class StepApp implements StepAppInterface {
  final StepRepository stepRepository;

  StepApp({required this.stepRepository});

  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> step) async {
    return stepRepository.create(step);
  }

  @override
  Future<Map<String, dynamic>> createMultiple(List<Map<String, dynamic>> steps) async {
    return stepRepository.createMultiple(steps);
  }

  @override
  Future<Map<String, dynamic>> getStep(String id) async {
    return stepRepository.getStep(id);
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    return stepRepository.list(conditions);
  }

  @override
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update) async {
    return stepRepository.update(id, update);
  }
}

abstract class StepAppInterface {
  Future<Map<String, dynamic>> create(Map<String, dynamic> step);
  Future<Map<String, dynamic>> createMultiple(List<Map<String, dynamic>> steps);
  Future<Map<String, dynamic>> getStep(String id);
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions);
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update);
}
