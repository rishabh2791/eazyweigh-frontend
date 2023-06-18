import 'package:eazyweigh/application/app_store.dart';
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

  bool selected = false;

  Job._({
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

  static Future<Job> fromServer(Map<String, dynamic> jsonObject) async {
    late Job job;

    await appStore.userApp.getUser(jsonObject["created_by_username"]).then((createdByResponse) async {
      await appStore.userApp.getUser(jsonObject["updated_by_username"]).then((updatedByResponse) async {
        await appStore.factoryApp.get(jsonObject["factory_id"]).then((factoryResponse) async {
          await appStore.materialApp.get(jsonObject["material_id"]).then((materialResponse) async {
            await appStore.unitOfMeasurementApp.get(jsonObject["unit_of_measurement_id"]).then((uomResponse) async {
              Map<String, dynamic> conditions = {
                "EQUALS": {
                  "Field": "job_id",
                  "Value": jsonObject["id"],
                }
              };
              List<JobItem> jobItems = [];
              bool complete = true;
              await appStore.jobItemApp.get(conditions).then((value) async {
                for (var item in value["payload"]) {
                  JobItem jobItem = await JobItem.fromServer(item);
                  jobItems.add(jobItem);
                  if (jobItem.material.isWeighed) {
                    complete = complete && jobItem.complete;
                  } else {
                    complete = complete && true;
                  }
                }
                job = Job._(
                  createdAt: DateTime.parse(jsonObject["created_at"]),
                  createdBy: await User.fromServer(createdByResponse["payload"]),
                  id: jsonObject["id"],
                  fact: await Factory.fromServer(factoryResponse["payload"]),
                  jobCode: jsonObject["job_code"],
                  material: await Mat.fromServer(materialResponse["payload"]),
                  processing: jsonObject["processing"],
                  quantity: double.parse(jsonObject["quantity"].toString()),
                  uom: await UnitOfMeasure.fromServer(uomResponse["payload"]),
                  complete: complete,
                  updatedAt: DateTime.parse(jsonObject["updated_at"]),
                  updatedBy: await User.fromServer(updatedByResponse["payload"]),
                  jobItems: jobItems,
                );
              });
            });
          });
        });
      });
    });

    return job;
  }
}
