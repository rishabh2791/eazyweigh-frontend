import 'package:eazyweigh/domain/repository/vessel_repository.dart';

class VesselApp implements VesselAppInterface {
  final VesselRepository vesselRepository;

  VesselApp({required this.vesselRepository});

  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> vessel) async {
    return vesselRepository.create(vessel);
  }

  @override
  Future<Map<String, dynamic>> createMultiple(List<Map<String, dynamic>> vessels) async {
    return vesselRepository.createMultiple(vessels);
  }

  @override
  Future<Map<String, dynamic>> getVessel(String id) async {
    return vesselRepository.getVessel(id);
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    return vesselRepository.list(conditions);
  }

  @override
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update) async {
    return vesselRepository.update(id, update);
  }
}

abstract class VesselAppInterface {
  Future<Map<String, dynamic>> create(Map<String, dynamic> vessel);
  Future<Map<String, dynamic>> createMultiple(List<Map<String, dynamic>> vessels);
  Future<Map<String, dynamic>> getVessel(String id);
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions);
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update);
}
