import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/job_item.dart';
import 'package:eazyweigh/domain/entity/user.dart';

class JobItemWeighing {
  final String id;
  final JobItem jobItem;
  final double weight;
  final String batch;
  final DateTime startTime;
  final DateTime endTime;
  final User createdBy;
  final DateTime createdAt;
  final User updatedBy;
  final DateTime updatedAt;
  bool verified;

  JobItemWeighing._({
    required this.createdAt,
    required this.createdBy,
    required this.endTime,
    required this.id,
    required this.batch,
    required this.jobItem,
    required this.startTime,
    required this.updatedAt,
    required this.updatedBy,
    required this.weight,
    this.verified = false,
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      "id": id,
      "batch": batch,
      "job_item_id": jobItem,
      "weight": weight,
      "start_time": startTime,
      "end_time": endTime,
      "created_by": createdBy.toJSON(),
      "created_at": createdAt,
      "updated_by": updatedBy.toJSON(),
      "updated_at": updatedAt,
      "verified": verified,
    };
  }

  static Future<JobItemWeighing> fromServer(Map<String, dynamic> jsonObject) async {
    late JobItemWeighing jobItemWeighing;

    await appStore.userApp.getUser(jsonObject["created_by_username"]).then((createdByResponse) async {
      await appStore.userApp.getUser(jsonObject["updated_by_username"]).then((updatedByResponse) async {
        Map<String, dynamic> jobItemConditions = {
          "EQUALS": {
            "Field": "id",
            "Value": jsonObject["job_item_id"],
          }
        };
        await appStore.jobItemApp.get(jobItemConditions).then((jobItemResponse) async {
          jobItemWeighing = JobItemWeighing._(
            createdAt: DateTime.parse(jsonObject["created_at"]),
            createdBy: await User.fromServer(createdByResponse["payload"]),
            endTime: DateTime.parse(jsonObject["end_time"]),
            id: jsonObject["id"],
            batch: jsonObject["batch"],
            jobItem: await JobItem.fromServer(jobItemResponse["payload"][0]),
            startTime: DateTime.parse(jsonObject["start_time"]),
            updatedAt: DateTime.parse(jsonObject["updated_at"]),
            updatedBy: await User.fromServer(updatedByResponse["payload"]),
            weight: double.parse(jsonObject["weight"].toString()),
            verified: jsonObject["verified"],
          );
        });
      });
    });

    return jobItemWeighing;
  }
}

class WeighingBatch {
  final DateTime createdAt;
  final DateTime updatedAt;
  final String id;
  final double weight;
  final String batch;
  final String createdByUsername;
  final String jobItemMaterialID;
  final double requiredWeight;
  final double actualWeight;
  final String jobCode;
  final String jobMaterialID;

  WeighingBatch._({
    required this.actualWeight,
    required this.jobCode,
    required this.jobItemMaterialID,
    required this.jobMaterialID,
    required this.requiredWeight,
    required this.batch,
    required this.createdAt,
    required this.createdByUsername,
    required this.id,
    required this.updatedAt,
    required this.weight,
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{};
  }

  static Future<WeighingBatch> fromServer(Map<String, dynamic> jsonObject) async {
    return WeighingBatch._(
      actualWeight: double.parse(jsonObject["actual_weight"]),
      jobCode: jsonObject["job_code"],
      jobItemMaterialID: jsonObject["job_item_material_id"],
      jobMaterialID: jsonObject["job_material_id"],
      requiredWeight: double.parse(jsonObject["required_weight"].toString()),
      batch: jsonObject["batch"],
      createdAt: DateTime.parse(jsonObject["created_at"]),
      createdByUsername: jsonObject["created_by_username"],
      id: jsonObject["id"],
      updatedAt: DateTime.parse(jsonObject["updated_at"]),
      weight: double.parse(jsonObject["weight"].toString()),
    );
  }
}
