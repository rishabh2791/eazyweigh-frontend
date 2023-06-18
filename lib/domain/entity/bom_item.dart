import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/material.dart';
import 'package:eazyweigh/domain/entity/unit_of_measure.dart';
import 'package:eazyweigh/domain/entity/user.dart';

class BomItem {
  final String id;
  final String bomID;
  final Mat material;
  double quantity;
  final double upperTolerance;
  final double lowerTolerance;
  final bool overIssue;
  final bool underIssue;
  final UnitOfMeasure uom;
  final DateTime createdAt;
  final User createdBy;
  final DateTime updatedAt;
  final User updatedBy;

  BomItem._({
    required this.bomID,
    required this.createdAt,
    required this.createdBy,
    required this.id,
    required this.material,
    required this.overIssue,
    required this.quantity,
    required this.upperTolerance,
    required this.lowerTolerance,
    required this.underIssue,
    required this.uom,
    required this.updatedAt,
    required this.updatedBy,
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      "bom_id": bomID,
      "created_at": createdAt,
      "created_by": createdBy.toJSON(),
      "id": id,
      "material": material.toJSON(),
      "over_issue": overIssue,
      "quantity": quantity,
      "upper_tolerance": upperTolerance,
      "lower_tolerance": lowerTolerance,
      "under_issue": underIssue,
      "unit_of_measurement": uom.toJSON(),
      "updated_at": updatedAt,
      "updated_by": updatedBy,
    };
  }

  static Future<BomItem> fromServer(Map<String, dynamic> jsonObject) async {
    late BomItem bomItem;

    await appStore.userApp.getUser(jsonObject["created_by_username"]).then((createdByResponse) async {
      await appStore.userApp.getUser(jsonObject["updated_by_username"]).then((updatedByResponse) async {
        await appStore.materialApp.get(jsonObject["material_id"]).then((materialResponse) async {
          await appStore.unitOfMeasurementApp.get(jsonObject["unit_of_measurement_id"]).then((uomResponse) async {
            bomItem = BomItem._(
              bomID: jsonObject["bom_id"],
              createdAt: DateTime.parse(jsonObject["created_at"]),
              createdBy: await User.fromServer(createdByResponse["payload"]),
              id: jsonObject["id"],
              material: await Mat.fromServer(materialResponse["payload"]),
              overIssue: jsonObject["over_issue"],
              quantity: double.parse(jsonObject["quantity"].toString()),
              upperTolerance: double.parse(jsonObject["upper_tolerance"].toString()),
              lowerTolerance: double.parse(jsonObject["lower_tolerance"].toString()),
              underIssue: jsonObject["under_issue"],
              uom: await UnitOfMeasure.fromServer(uomResponse["payload"]),
              updatedAt: DateTime.parse(jsonObject["updated_at"]),
              updatedBy: await User.fromServer(updatedByResponse["payload"]),
            );
          });
        });
      });
    });

    return bomItem;
  }
}
