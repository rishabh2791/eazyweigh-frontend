import 'package:eazyweigh/domain/entity/unit_of_measure.dart';
import 'package:eazyweigh/domain/entity/user.dart';

class UnderIssue {
  final String id;
  final String jobItem;
  final UnitOfMeasure uom;
  final double req;
  final double actual;
  final bool verified;
  final bool weighed;
  final DateTime createdAt;
  final User createdBy;
  final DateTime updatedAt;
  final User updatedBy;

  UnderIssue({
    required this.actual,
    required this.verified,
    required this.createdAt,
    required this.createdBy,
    required this.id,
    required this.jobItem,
    required this.req,
    required this.uom,
    required this.weighed,
    required this.updatedAt,
    required this.updatedBy,
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      "actual": actual,
      "verified": verified,
      "created_at": createdAt,
      "created_by": createdBy.toJSON(),
      "id": id,
      "job_item": jobItem,
      "required": req,
      "Weighed": weighed,
      "unit_of_measurement": uom.toJSON(),
      "updated_at": updatedAt,
      "updated_by": updatedBy.toJSON(),
    };
  }

  factory UnderIssue.fromJSON(Map<String, dynamic> jsonObject) {
    UnderIssue underIssue = UnderIssue(
      actual: jsonObject["actual"],
      verified: jsonObject["verified"],
      createdAt: DateTime.parse(jsonObject["created_at"]),
      createdBy: User.fromJSON(jsonObject["created_by"]),
      id: jsonObject["id"],
      jobItem: jsonObject["job_item"],
      req: jsonObject["required"],
      weighed: jsonObject["weighed"],
      uom: UnitOfMeasure.fromJSON(jsonObject["unit_of_measurement"]),
      updatedAt: DateTime.parse(jsonObject["udpated_at"]),
      updatedBy: User.fromJSON(jsonObject["updated_by"]),
    );
    return underIssue;
  }
}
