import 'package:eazyweigh/domain/entity/material.dart';
import 'package:eazyweigh/domain/entity/unit_of_measure.dart';
import 'package:eazyweigh/domain/entity/user.dart';

class JobItem {
  String id;
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

  JobItem({
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

  factory JobItem.fromJSON(Map<String, dynamic> jsonObject) {
    JobItem jobItem = JobItem(
      actualWeight: double.parse(jsonObject["actual_weight"].toString()),
      assigned: jsonObject["assigned"],
      complete: jsonObject["complete"],
      createdAt: DateTime.parse(jsonObject["created_at"]).toLocal(),
      createdBy: User.fromJSON(jsonObject["created_by"]),
      id: jsonObject["id"],
      jobID: jsonObject["job_id"],
      lowerBound: double.parse(jsonObject["lower_bound"].toString()),
      material: Mat.fromJSON(jsonObject["material"]),
      requiredWeight: double.parse(jsonObject["required_weight"].toString()),
      uom: UnitOfMeasure.fromJSON(jsonObject["unit_of_measurement"]),
      updatedAt: DateTime.parse(jsonObject["updated_at"]).toLocal(),
      updatedBy: User.fromJSON(jsonObject["updated_by"]),
      upperBound: double.parse(jsonObject["upper_bound"].toString()),
      verified: jsonObject["verified"],
      added: jsonObject["added"],
    );
    return jobItem;
  }
}
