import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/job.dart';
import 'package:eazyweigh/domain/entity/process.dart';
import 'package:eazyweigh/domain/entity/user.dart';
import 'package:eazyweigh/domain/entity/vessel.dart';

class Batch {
  final String id;
  final Job job;
  final Process process;
  final Vessel vessel;
  final DateTime startTime;
  final DateTime endTime;
  final User createdBy;
  final DateTime createdAt;
  final User updatedBy;
  final DateTime updatedAt;

  Batch._({
    required this.createdAt,
    required this.createdBy,
    required this.job,
    required this.process,
    required this.id,
    required this.updatedAt,
    required this.updatedBy,
    required this.vessel,
    required this.endTime,
    required this.startTime,
  });

  @override
  String toString() {
    return process.material.code + " - " + process.material.description;
  }

  Map<String, dynamic> toJSON() {
    return {
      "id": id,
      "job": job.toJSON(),
      "process": process.toJSON(),
      "vessel": vessel.toJSON(),
      "start_time": startTime,
      "end_time": endTime,
      "created_at": createdAt,
      "created_by": createdBy.toJSON(),
      "updated_at": updatedAt,
      "updated_by": updatedBy.toJSON(),
    };
  }

  static Future<Batch> fromServer(Map<String, dynamic> jsonObject) async {
    late Batch batch;

    await appStore.userApp.getUser(jsonObject["created_by_username"]).then((createdByResponse) async {
      await appStore.userApp.getUser(jsonObject["updated_by_username"]).then((updatedByResponse) async {
        await appStore.vesselApp.getVessel(jsonObject["vessel_id"]).then((vesselResponse) async {
          await appStore.processApp.getProcess(jsonObject["process_id"]).then((processResponse) async {
            await appStore.jobApp.get(jsonObject["job_id"]).then((jobResponse) async {
              batch = Batch._(
                createdAt: DateTime.parse(jsonObject["created_at"]),
                createdBy: await User.fromServer(createdByResponse["payload"]),
                job: await Job.fromServer(jobResponse["payload"]),
                process: await Process.fromServer(processResponse["payload"]),
                id: jsonObject["id"],
                updatedAt: DateTime.parse(jsonObject["updated_at"]),
                updatedBy: await User.fromServer(updatedByResponse["payload"]),
                vessel: await Vessel.fromServer(vesselResponse["payload"]),
                endTime: DateTime.parse(jsonObject["end_time"]),
                startTime: DateTime.parse(jsonObject["start_time"]),
              );
            });
          });
        });
      });
    });

    return batch;
  }
}
