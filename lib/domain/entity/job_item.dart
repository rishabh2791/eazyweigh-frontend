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
  final bool assigned;
  final bool verified;
  final DateTime createdAt;
  final User createdBy;
  final DateTime updatedAt;
  final User updatedBy;

  bool selected = false;

  JobItem({
    required this.actualWeight,
    required this.assigned,
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
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      "actual_weight": actualWeight,
      "assigned": assigned,
      "created_at": createdAt,
      "created_by": createdBy,
      "id": id,
      "job_id": jobID,
      "lower_bound": lowerBound,
      "material": material.toJSON(),
      "required_weight": requiredWeight,
      "unit_of_measure": uom.toJSON(),
      "updated_at": updatedAt,
      "updated_by": updatedBy,
      "upper_bound": upperBound,
      "verified": verified,
    };
  }

  factory JobItem.fromJSON(Map<String, dynamic> jsonObject) {
    JobItem jobItem = JobItem(
      actualWeight: double.parse(jsonObject["actual_weight"].toString()),
      assigned: jsonObject["assigned"],
      createdAt: DateTime.parse(jsonObject["created_at"]),
      createdBy: User.fromJSON(jsonObject["created_by"]),
      id: jsonObject["id"],
      jobID: jsonObject["job_id"],
      lowerBound: double.parse(jsonObject["lower_bound"].toString()),
      material: Mat.fromJSON(jsonObject["material"]),
      requiredWeight: double.parse(jsonObject["required_weight"].toString()),
      uom: UnitOfMeasure.fromJSON(jsonObject["unit_of_measurement"]),
      updatedAt: DateTime.parse(jsonObject["updated_at"]),
      updatedBy: User.fromJSON(jsonObject["updated_by"]),
      upperBound: double.parse(jsonObject["upper_bound"].toString()),
      verified: jsonObject["verified"],
    );
    return jobItem;
  }
}
