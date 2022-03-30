import 'package:eazyweigh/domain/entity/factory.dart';
import 'package:eazyweigh/domain/entity/job_item.dart';
import 'package:eazyweigh/domain/entity/material.dart';
import 'package:eazyweigh/domain/entity/unit_of_measure.dart';
import 'package:eazyweigh/domain/entity/user.dart';

class Job {
  final String id;
  final String jobCode;
  final Mat material;
  final Factory fact;
  final double quantity;
  final UnitOfMeasure uom;
  final bool processing;
  final DateTime createdAt;
  final User createdBy;
  final bool complete;
  final DateTime updatedAt;
  final User updatedBy;
  final List<JobItem> jobItems;

  Job({
    required this.createdAt,
    required this.createdBy,
    required this.id,
    required this.fact,
    required this.jobCode,
    required this.material,
    required this.processing,
    required this.quantity,
    required this.uom,
    required this.complete,
    required this.updatedAt,
    required this.updatedBy,
    this.jobItems = const [],
  });

  Map<String, dynamic> toJSON() {
    List<Map<String, dynamic>> jobItemsList = [];
    for (var jobItem in jobItems) {
      jobItemsList.add(jobItem.toJSON());
    }
    return <String, dynamic>{
      "created_at": createdAt,
      "created_by": createdBy.toJSON(),
      "id": id,
      "factory": fact.toJSON(),
      "job_code": jobCode,
      "material": material.toJSON(),
      "processing": processing,
      "quantity": quantity,
      "unit_of_measure": uom.toJSON(),
      "complete": complete,
      "updated_at": updatedAt,
      "updated_by": updatedBy.toJSON(),
      "job_item": jobItemsList,
    };
  }

  factory Job.fromJSON(Map<String, dynamic> jsonObject) {
    List<JobItem> jobItems = [];
    for (Map<String, dynamic> item in jsonObject["job_items"]) {
      JobItem jobItem = JobItem.fromJSON(item);
      jobItems.add(jobItem);
    }
    Job job = Job(
      createdAt: DateTime.parse(jsonObject["created_at"]),
      createdBy: User.fromJSON(jsonObject["created_by"]),
      id: jsonObject["id"],
      fact: Factory.fromJSON(jsonObject["factory"]),
      jobCode: jsonObject["job_code"],
      material: Mat.fromJSON(jsonObject["material"]),
      processing: jsonObject["processing"],
      complete: jsonObject["complete"],
      quantity: double.parse(jsonObject["quantity"].toString()),
      uom: UnitOfMeasure.fromJSON(jsonObject["unit_of_measurement"]),
      updatedAt: DateTime.parse(jsonObject["updated_at"]),
      updatedBy: User.fromJSON(jsonObject["updated_by"]),
      jobItems: jobItems,
    );
    return job;
  }
}
