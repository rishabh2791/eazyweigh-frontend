import 'package:eazyweigh/application/app_store.dart';
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

  ScannedData._({
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

  static Future<ScannedData> fromServer(Map<String, dynamic> jsonObject) async {
    late ScannedData scannedData;

    await appStore.userApp.getUser(jsonObject["user_username"]).then((userResponse) async {
      await appStore.terminalApp.get(jsonObject["terminal_id"]).then((terminalResponse) async {
        await appStore.jobApp.get(jsonObject["job_id"]).then((jobResponse) async {
          scannedData = ScannedData._(
            actualCode: jsonObject["scanned_data"],
            expectedCode: jsonObject["expected_code"],
            id: jsonObject["id"],
            job: await Job.fromServer(jobResponse["payload"]),
            weigher: await User.fromServer(userResponse["payload"]),
            createdAt: DateTime.parse(jsonObject["created_at"]),
            terminal: await Terminal.fromServer(terminalResponse["payload"]),
            updatedAt: DateTime.parse(jsonObject["updated_at"]),
          );
        });
      });
    });

    return scannedData;
  }
}
