import 'package:eazyweigh/domain/entity/material.dart';
import 'package:eazyweigh/domain/entity/unit_of_measure.dart';
import 'package:eazyweigh/domain/entity/user.dart';

class JobItem {
  final String id;
  final String jobID;
  final Material material;
  final UnitOfMeasure uom;
  final double requiredWeight;
  final double upperBound;
  final double lowerBound;
  final bool overIssue;
  final bool underIssue;
  final double actualWeight;
  final bool complete;
  final DateTime createdAt;
  final User createdBy;
  final DateTime updatedAt;
  final User updatedBy;

  JobItem({
    required this.actualWeight,
    required this.complete,
    required this.createdAt,
    required this.createdBy,
    required this.id,
    required this.jobID,
    required this.lowerBound,
    required this.material,
    required this.overIssue,
    required this.requiredWeight,
    required this.underIssue,
    required this.uom,
    required this.updatedAt,
    required this.updatedBy,
    required this.upperBound,
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      "actual_weight": actualWeight,
      "complete": complete,
      "created_at": createdAt,
      "created_by": createdBy,
      "id": id,
      "job_id": jobID,
      "lower_bound": lowerBound,
      "material": material.toJSON(),
      "over_issue": overIssue,
      "required_weight": requiredWeight,
      "under_issue": underIssue,
      "unit_of_measure": uom.toJSON(),
      "updated_at": updatedAt,
      "updated_by": updatedBy,
      "upper_bound": upperBound,
    };
  }

  factory JobItem.fromJSON(Map<String, dynamic> jsonObject) {
    JobItem jobItem = JobItem(
      actualWeight: jsonObject["actual_weight"],
      complete: jsonObject["complete"],
      createdAt: DateTime.parse(jsonObject["created_at"]),
      createdBy: User.fromJSON(jsonObject["created_by"]),
      id: jsonObject["id"],
      jobID: jsonObject["job_id"],
      lowerBound: jsonObject["lower_bound"],
      material: Material.fromJSON(jsonObject["material"]),
      overIssue: jsonObject["over_issue"],
      requiredWeight: jsonObject["required_weight"],
      underIssue: jsonObject["under_issue"],
      uom: UnitOfMeasure.fromJSON(jsonObject["unit_of_measure"]),
      updatedAt: DateTime.parse(jsonObject["updated_at"]),
      updatedBy: User.fromJSON(jsonObject["updated_by"]),
      upperBound: jsonObject["upper_bound"],
    );
    return jobItem;
  }
}
