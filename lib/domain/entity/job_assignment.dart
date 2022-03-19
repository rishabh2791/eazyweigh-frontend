import 'package:eazyweigh/domain/entity/job.dart';
import 'package:eazyweigh/domain/entity/shift_schedule.dart';
import 'package:eazyweigh/domain/entity/user.dart';

class JobAssignment {
  final String id;
  final Job job;
  final ShiftSchedule shiftSchedule;
  final DateTime startTime;
  final DateTime endTime;
  final User createdBy;
  final DateTime createdAt;
  final User updatedBy;
  final DateTime updatedAt;

  JobAssignment({
    required this.createdAt,
    required this.createdBy,
    required this.endTime,
    required this.id,
    required this.job,
    required this.shiftSchedule,
    required this.startTime,
    required this.updatedAt,
    required this.updatedBy,
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      "created_at": createdAt,
      "created_by": createdBy.toJSON(),
      "end_time": endTime,
      "id": id,
      "job": job.toJSON(),
      "shift_schedule": shiftSchedule.toJSON(),
      "start_time": startTime,
      "updated_at": updatedAt,
      "updated_by": updatedBy.toJSON(),
    };
  }

  factory JobAssignment.fromJSON(Map<String, dynamic> jsonObject) {
    JobAssignment jobAssignment = JobAssignment(
      createdAt: DateTime.parse(jsonObject["created_at"]),
      createdBy: User.fromJSON(jsonObject["created_by"]),
      endTime: DateTime.parse(jsonObject["end_time"]),
      id: jsonObject["id"],
      job: Job.fromJSON(jsonObject["job"]),
      shiftSchedule: ShiftSchedule.fromJSON(jsonObject["shift_schedule"]),
      startTime: DateTime.parse(jsonObject["start_time"]),
      updatedAt: DateTime.parse(jsonObject["updated_at"]),
      updatedBy: User.fromJSON(jsonObject["updated_by"]),
    );
    return jobAssignment;
  }
}
