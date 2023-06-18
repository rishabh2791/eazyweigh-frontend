import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/material.dart';
import 'package:eazyweigh/domain/entity/unit_of_measure.dart';
import 'package:eazyweigh/domain/entity/user.dart';

class JobItem {
  final String id;
  final String jobID;
  final Mat material;
  final UnitOfMeasure uom;
  double requiredWeight;
  final double upperBound;
  final double lowerBound;
  double actualWeight;
  bool assigned;
  bool verified;
  bool complete;
  bool added;
  final DateTime createdAt;
  final User createdBy;
  final DateTime updatedAt;
  final User updatedBy;

  bool selected = false;

  JobItem._({
    required this.actualWeight,
    required this.assigned,
    required this.complete,
    required this.createdAt,
    required this.createdBy,
    required this.id,
    required this.jobID,
    required this.lowerBound,
    required this.material,
    required this.requiredWeight,
    required this.uom,
    required this.updatedAt,
    required this.updatedBy,
    required this.upperBound,
    required this.verified,
    required this.added,
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      "actual_weight": actualWeight,
      "assigned": assigned,
      "complete": complete,
      "created_at": createdAt,
      "created_by": createdBy.toJSON(),
      "id": id,
      "job_id": jobID,
      "lower_bound": lowerBound,
      "material": material.toJSON(),
      "required_weight": requiredWeight,
      "unit_of_measure": uom.toJSON(),
      "updated_at": updatedAt,
      "updated_by": updatedBy.toJSON(),
      "upper_bound": upperBound,
      "verified": verified,
      "added": added,
    };
  }

  static Future<JobItem> fromServer(Map<String, dynamic> jsonObject) async {
    late JobItem jobItem;
    await appStore.userApp.getUser(jsonObject["created_by_username"]).then((createdByResponse) async {
      await appStore.userApp.getUser(jsonObject["updated_by_username"]).then((updatedByResponse) async {
        await appStore.materialApp.get(jsonObject["material_id"]).then((materialResponse) async {
          await appStore.unitOfMeasurementApp.get(jsonObject["unit_of_measurement_id"]).then((uomResponse) async {
            jobItem = JobItem._(
              actualWeight: double.parse(jsonObject["actual_weight"].toString()),
              assigned: jsonObject["assigned"],
              complete: jsonObject["complete"],
              createdAt: DateTime.parse(jsonObject["created_at"]),
              createdBy: await User.fromServer(createdByResponse["payload"]),
              id: jsonObject["id"],
              jobID: jsonObject["job_id"],
              lowerBound: double.parse(jsonObject["lower_bound"].toString()),
              material: await Mat.fromServer(materialResponse["payload"]),
              requiredWeight: double.parse(jsonObject["required_weight"].toString()),
              uom: await UnitOfMeasure.fromServer(uomResponse["payload"]),
              updatedAt: DateTime.parse(jsonObject["updated_at"]),
              updatedBy: await User.fromServer(updatedByResponse["payload"]),
              upperBound: double.parse(jsonObject["upper_bound"].toString()),
              verified: jsonObject["verified"],
              added: jsonObject["added"],
            );
          });
        });
      });
    });

    return jobItem;
  }
}
