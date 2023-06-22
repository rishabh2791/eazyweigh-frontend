import 'package:eazyweigh/domain/entity/job.dart';
import 'package:eazyweigh/domain/entity/terminals.dart';
import 'package:eazyweigh/domain/entity/user.dart';

class ScannedData {
  final String id;
  final String actualCode;
  final String expectedCode;
  final Terminal terminal;
  final User weigher;
  final Job job;
  final DateTime createdAt;
  final DateTime updatedAt;

  ScannedData({
    required this.actualCode,
    required this.expectedCode,
    required this.id,
    required this.job,
    required this.weigher,
    required this.createdAt,
    required this.terminal,
    required this.updatedAt,
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      "actual_code": actualCode,
      "expected_code": expectedCode,
      "id": id,
      "job": job.toJSON(),
      "user": weigher.toJSON(),
    };
  }

  factory ScannedData.fromJSON(Map<String, dynamic> jsonObject) {
    ScannedData scannedData = ScannedData(
      actualCode: jsonObject["actual_code"],
      expectedCode: jsonObject["expected_code"],
      id: jsonObject["id"],
      job: Job.fromJSON(jsonObject["job"]),
      weigher: User.fromJSON(jsonObject["user"]),
      terminal: Terminal.fromJSON(jsonObject["terminal"]),
      createdAt: DateTime.parse(jsonObject["created_at"]).toLocal(),
      updatedAt: DateTime.parse(jsonObject["updated_at"]).toLocal(),
    );
    return scannedData;
  }
}
