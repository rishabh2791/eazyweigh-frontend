import 'package:eazyweigh/domain/entity/material.dart';
import 'package:eazyweigh/domain/entity/unit_of_measure.dart';
import 'package:eazyweigh/domain/entity/user.dart';

class Job {
  final String id;
  final String jobCode;
  final Material material;
  final double quantity;
  final UnitOfMeasure uom;
  final bool processing;
  final DateTime createdAt;
  final User createdBy;
  final DateTime updatedAt;
  final User updatedBy;

  Job({
    required this.createdAt,
    required this.createdBy,
    required this.id,
    required this.jobCode,
    required this.material,
    required this.processing,
    required this.quantity,
    required this.uom,
    required this.updatedAt,
    required this.updatedBy,
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      "created_at": createdAt,
      "created_by": createdBy,
      "id": id,
      "job_code": jobCode,
      "material": material.toJSON(),
      "processing": processing,
      "quantity": quantity,
      "unit_of_measure": uom.toJSON(),
      "updated_at": updatedAt,
      "updated_by": updatedBy,
    };
  }

  factory Job.fromJSON(Map<String, dynamic> jsonObject) {
    Job job = Job(
      createdAt: DateTime.parse(jsonObject["created_at"]),
      createdBy: User.fromJSON(jsonObject["created_at"]),
      id: jsonObject["id"],
      jobCode: jsonObject["job_code"],
      material: Material.fromJSON(jsonObject["material"]),
      processing: jsonObject["processing"],
      quantity: jsonObject["quantity"],
      uom: UnitOfMeasure.fromJSON(jsonObject["unit_of_measure"]),
      updatedAt: DateTime.parse(jsonObject["updated_at"]),
      updatedBy: jsonObject["updated_by"],
    );
    return job;
  }
}
