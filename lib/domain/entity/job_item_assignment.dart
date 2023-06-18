import 'package:eazyweigh/application/app_store.dart';
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

  JobItemAssignment._({
    required this.createdAt,
    required this.createdBy,
    required this.id,
    required this.jobItem,
    required this.shiftSchedule,
    required this.updatedAt,
    required this.updatedBy,
  });

  bool selected = false;

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

  static Future<JobItemAssignment> fromServer(Map<String, dynamic> jsonObject) async {
    late JobItemAssignment jobItemAssignment;

    await appStore.userApp.getUser(jsonObject["created_by_username"]).then((createdByResponse) async {
      await appStore.userApp.getUser(jsonObject["updated_by_username"]).then((updatedByResponse) async {
        Map<String, dynamic> jobItemConditions = {
          "EQUALS": {
            "Field": "id",
            "Value": jsonObject["job_item_id"],
          }
        };
        await appStore.jobItemApp.get(jobItemConditions).then((jobItemResponse) async {
          Map<String, dynamic> shiftScheduleConditions = {
            "EQUALS": {
              "Field": "id",
              "Value": jsonObject["shift_schedule_id"],
            }
          };
          await appStore.shiftScheduleApp.list(shiftScheduleConditions).then((shiftScheduleResponse) async {
            jobItemAssignment = JobItemAssignment._(
              createdAt: DateTime.parse(jsonObject["created_at"]),
              createdBy: await User.fromServer(createdByResponse["payload"]),
              id: jsonObject["id"],
              jobItem: await JobItem.fromServer(jobItemResponse["payload"][0]),
              shiftSchedule: await ShiftSchedule.fromServer(shiftScheduleResponse["payload"][0]),
              updatedAt: DateTime.parse(jsonObject["updated_at"]),
              updatedBy: await User.fromServer(updatedByResponse["payload"]),
            );
          });
        });
      });
    });

    return jobItemAssignment;
  }
}
