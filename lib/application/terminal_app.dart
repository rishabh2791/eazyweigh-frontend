import 'package:eazyweigh/domain/repository/terminal_repository.dart';

class TerminalApp implements TerminalAppInterface {
  TerminalRepository terminalRepository;

  TerminalApp({
    required this.terminalRepository,
  });

  @override
  Future<Map<String, dynamic>> create(Map<String, dynamic> terminal) async {
    return terminalRepository.create(terminal);
  }

  @override
  Future<Map<String, dynamic>> createMultiple(List<Map<String, dynamic>> terminals) async {
    return terminalRepository.createMultiple(terminals);
  }

  @override
  Future<Map<String, dynamic>> get(String id) async {
    return terminalRepository.get(id);
  }

  @override
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions) async {
    return terminalRepository.list(conditions);
  }

  @override
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update) async {
    return terminalRepository.update(id, update);
  }
}

abstract class TerminalAppInterface {
  Future<Map<String, dynamic>> create(Map<String, dynamic> terminal);
  Future<Map<String, dynamic>> createMultiple(List<Map<String, dynamic>> terminals);
  Future<Map<String, dynamic>> get(String id);
  Future<Map<String, dynamic>> list(Map<String, dynamic> conditions);
  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> update);
}
