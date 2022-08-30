import 'package:eazyweigh/domain/repository/step_type_repository.dart';

class StepTypeApp implements StepTypeAppInterface {
  final StepTypeRepository stepTypeRepository;

  StepTypeApp({required this.stepTypeRepository});

  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> stepType) async {
    return stepTypeRepository.create(stepType);
  }

  @override
  Future<Map<String, dynamic>> createMultiple(List<Map<String, dynamic>> stepTypes) async {
    return stepTypeRepository.createMultiple(stepTypes);
  }

  @override
  Future<Map<String, dynamic>> getStepType(String id) async {
    return stepTypeRepository.getStepType(id);
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    return stepTypeRepository.list(conditions);
  }

  @override
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update) async {
    return stepTypeRepository.update(id, update);
  }
}

abstract class StepTypeAppInterface {
  Future<Map<String, dynamic>> create(Map<String, dynamic> stepType);
  Future<Map<String, dynamic>> createMultiple(List<Map<String, dynamic>> stepTypes);
  Future<Map<String, dynamic>> getStepType(String id);
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions);
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update);
}
