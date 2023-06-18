import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/job_item.dart';
import 'package:eazyweigh/domain/entity/unit_of_measure.dart';
import 'package:eazyweigh/domain/entity/user.dart';

class UnderIssue {
  final String id;
  final JobItem jobItem;
  final UnitOfMeasure uom;
  final double req;
  final double actual;
  bool verified;
  final bool weighed;
  final DateTime createdAt;
  final User createdBy;
  final DateTime updatedAt;
  final User updatedBy;
  final double weight;

  bool selected = false;

  UnderIssue._({
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
    required this.weight,
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
      "weight": weight,
    };
  }

  static Future<UnderIssue> fromServer(Map<String, dynamic> jsonObject) async {
    late UnderIssue underIssue;

    await appStore.userApp.getUser(jsonObject["created_by_username"]).then((createdByResponse) async {
      await appStore.userApp.getUser(jsonObject["updated_by_username"]).then((updatedByResponse) async {
        await appStore.unitOfMeasurementApp.get(jsonObject["unit_of_measurement_id"]).then((uomResponse) async {
          Map<String, dynamic> conditions = {
            "EQUALS": {
              "Field": "id",
              "Value": jsonObject["job_item_id"],
            }
          };
          await appStore.jobItemApp.get(conditions).then((jobItemResponse) async {
            underIssue = UnderIssue._(
              actual: double.parse(jsonObject["actual"].toString()),
              verified: jsonObject["verified"],
              createdAt: DateTime.parse(jsonObject["created_at"]),
              createdBy: await User.fromServer(createdByResponse["payload"]),
              id: jsonObject["id"],
              jobItem: await JobItem.fromServer(jobItemResponse["payload"]),
              req: double.parse(jsonObject["required"].toString()),
              uom: await UnitOfMeasure.fromServer(uomResponse["payload"]),
              weighed: jsonObject["weighed"],
              updatedAt: DateTime.parse(jsonObject["updated_at"]),
              updatedBy: await User.fromServer(updatedByResponse["payload"]),
              weight: double.parse(jsonObject["weight"].toString()),
            );
          });
        });
      });
    });

    return underIssue;
  }
}
