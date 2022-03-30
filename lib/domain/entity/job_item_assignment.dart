import 'package:eazyweigh/domain/entity/job_item.dart';
import 'package:eazyweigh/domain/entity/shift_schedule.dart';
import 'package:eazyweigh/domain/entity/user.dart';

class JobItemAssignment {
  final String id;
  final JobItem jobItem;
  final ShiftSchedule shiftSchedule;
  final User createdBy;
  final DateTime createdAt;
  final User updatedBy;
  final DateTime updatedAt;

  JobItemAssignment({
    required this.createdAt,
    required this.createdBy,
    required this.id,
    required this.jobItem,
    required this.shiftSchedule,
    required this.updatedAt,
    required this.updatedBy,
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      "created_at": createdAt,
      "created_by": createdBy.toJSON(),
      "id": id,
      "job": jobItem.toJSON(),
      "shift_schedule": shiftSchedule.toJSON(),
      "updated_at": updatedAt,
      "updated_by": updatedBy.toJSON(),
    };
  }

  factory JobItemAssignment.fromJSON(Map<String, dynamic> jsonObject) {
    JobItemAssignment jobAssignment = JobItemAssignment(
      createdAt: DateTime.parse(jsonObject["created_at"]),
      createdBy: User.fromJSON(jsonObject["created_by"]),
      id: jsonObject["id"],
      jobItem: JobItem.fromJSON(jsonObject["job_item"]),
      shiftSchedule: ShiftSchedule.fromJSON(jsonObject["shift_schedule"]),
      updatedAt: DateTime.parse(jsonObject["updated_at"]),
      updatedBy: User.fromJSON(jsonObject["updated_by"]),
    );
    print(jobAssignment.jobItem.material);
    return jobAssignment;
  }
}
