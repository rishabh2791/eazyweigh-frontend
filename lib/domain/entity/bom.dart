import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/material.dart';
import 'package:eazyweigh/domain/entity/unit_of_measure.dart';
import 'package:eazyweigh/domain/entity/user.dart';

class BOM {
  final String id;
  final String factoryID;
  final Mat material;
  final int revision;
  final UnitOfMeasure uom;
  final double unitSize;
  final DateTime createdAt;
  final User createdBy;
  final DateTime updatedAt;
  final User updatedBy;

  BOM._({
    required this.createdAt,
    required this.createdBy,
    required this.id,
    required this.material,
    required this.revision,
    required this.unitSize,
    required this.uom,
    required this.updatedAt,
    required this.updatedBy,
    required this.factoryID,
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      "created_at": createdAt,
      "created_by": createdBy,
      "id": id,
      "factory_id": factoryID,
      "revision": revision,
      "material": material.toJSON(),
      "unit_size": unitSize,
      "unit_of_measure": uom.toJSON(),
      "updated_at": updatedAt,
      "updated_by": updatedBy,
    };
  }

  static Future<BOM> fromServer(Map<String, dynamic> jsonObject) async {
    late BOM bom;

    await appStore.userApp.getUser(jsonObject["created_by_username"]).then((createdByResponse) async {
      await appStore.userApp.getUser(jsonObject["updated_by_username"]).then((updatedByResponse) async {
        await appStore.materialApp.get(jsonObject["material_id"]).then((materialResponse) async {
          await appStore.unitOfMeasurementApp.get(jsonObject["unit_of_measurement_id"]).then((uomResponse) async {
            bom = BOM._(
              createdAt: DateTime.parse(jsonObject["created_at"]),
              createdBy: await User.fromServer(createdByResponse["payload"]),
              id: jsonObject["id"],
              material: await Mat.fromServer(materialResponse["payload"]),
              revision: int.parse(jsonObject["int"]),
              unitSize: double.parse(jsonObject["unit_size"].toString()),
              uom: await UnitOfMeasure.fromServer(uomResponse["payload"]),
              updatedAt: DateTime.parse(jsonObject["updated_at"]),
              updatedBy: await User.fromServer(updatedByResponse["payload"]),
              factoryID: jsonObject["factory_id"],
            );
          });
        });
      });
    });

    return bom;
  }
}
