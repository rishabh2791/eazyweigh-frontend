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

  Batch({
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

  factory Batch.fromJSON(Map<String, dynamic> jsonObject) {
    Batch batch = Batch(
      createdAt: DateTime.parse(jsonObject["created_at"]),
      createdBy: User.fromJSON(jsonObject["created_by"]),
      job: Job.fromJSON(jsonObject["job"]),
      process: Process.fromJSON(jsonObject["process"]),
      id: jsonObject["id"],
      endTime: DateTime.parse(jsonObject["end_time"]).toLocal(),
      startTime: DateTime.parse(jsonObject["start_time"]).toLocal(),
      updatedAt: DateTime.parse(jsonObject["updated_at"]),
      updatedBy: User.fromJSON(jsonObject["updated_by"]),
      vessel: Vessel.fromJSON(jsonObject["vessel"]),
    );
    return batch;
  }
}
