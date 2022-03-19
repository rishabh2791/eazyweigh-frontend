import 'package:eazyweigh/domain/repository/address_repository.dart';

class AddressApp implements AddressAppInterface {
  AddressRepository addressRepository;
  AddressApp({
    required this.addressRepository,
  });

  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> address) async {
    return addressRepository.create(address);
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    return addressRepository.list(conditions);
  }

  @override
  Future<Map<String, dynamic>> update(
      String id, Map<String, dynamic> update) async {
    return addressRepository.update(id, update);
  }

  @override
  Future<Map<String, dynamic>> delete(String id) async {
    return addressRepository.delete(id);
  }
}

abstract class AddressAppInterface {
  Future<Map<String, dynamic>> create(Map<String, dynamic> address);
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions);
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update);
  Future<Map<String, dynamic>> delete(String id);
}
