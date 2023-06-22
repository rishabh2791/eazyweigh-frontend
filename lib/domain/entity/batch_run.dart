import 'package:eazyweigh/domain/entity/job.dart';
import 'package:eazyweigh/domain/entity/user.dart';
import 'package:eazyweigh/domain/entity/vessel.dart';

class BatchRun {
  final String id;
  final Job job;
  final Vessel vessel;
  final DateTime startTime;
  final DateTime endTime;
  final User createdBy;
  final DateTime createdAt;
  final User updatedBy;
  final DateTime updatedAt;

  BatchRun({
    required this.createdAt,
    required this.createdBy,
    required this.job,
    required this.id,
    required this.updatedAt,
    required this.updatedBy,
    required this.vessel,
    required this.endTime,
    required this.startTime,
  });

  @override
  String toString() {
    return job.material.code + " - " + job.material.description;
  }

  Map<String, dynamic> toJSON() {
    return {
      "id": id,
      "job": job.toJSON(),
      "vessel": vessel.toJSON(),
      "start_time": startTime,
      "end_time": endTime,
      "created_at": createdAt,
      "created_by": createdBy.toJSON(),
      "updated_at": updatedAt,
      "updated_by": updatedBy.toJSON(),
    };
  }

  factory BatchRun.fromJSON(Map<String, dynamic> jsonObject) {
    BatchRun batchRun = BatchRun(
      createdAt: DateTime.parse(jsonObject["created_at"]),
      createdBy: User.fromJSON(jsonObject["created_by"]),
      job: Job.fromJSON(jsonObject["job"]),
      id: jsonObject["id"],
      endTime: DateTime.parse(jsonObject["end_time"]).toLocal(),
      startTime: DateTime.parse(jsonObject["start_time"]).toLocal(),
      updatedAt: DateTime.parse(jsonObject["updated_at"]),
      updatedBy: User.fromJSON(jsonObject["updated_by"]),
      vessel: Vessel.fromJSON(jsonObject["vessel"]),
    );
    return batchRun;
  }
}
