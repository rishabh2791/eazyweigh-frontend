import 'package:eazyweigh/domain/repository/scanned_data_repository.dart';

class ScannedDataApp implements ScannedDataAppInterface {
  ScannedDataRepository scannedDataRepository;

  ScannedDataApp({
    required this.scannedDataRepository,
  });

  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> scannedData) async {
    return scannedDataRepository.create(scannedData);
  }

  @override
  Future<Map<String, dynamic>> get(String id) async {
    return scannedDataRepository.get(id);
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    return scannedDataRepository.list(conditions);
  }
}

abstract class ScannedDataAppInterface {
  Future<Map<String, dynamic>> create(Map<String, dynamic> scannedData);
  Future<Map<String, dynamic>> get(String id);
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions);
}
