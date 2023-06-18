import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/unit_of_measure.dart';
import 'package:eazyweigh/domain/entity/user.dart';

class UnitOfMeasurementConversion {
  final String id;
  final String factoryID;
  final UnitOfMeasure unitOfMeasure1;
  final UnitOfMeasure unitOfMeasure2;
  final double value1;
  final double value2;
  final User createdBy;
  final DateTime createdAt;
  final User updatedBy;
  final DateTime updatedAt;

  UnitOfMeasurementConversion._({
    required this.createdAt,
    required this.createdBy,
    required this.factoryID,
    required this.id,
    required this.unitOfMeasure1,
    required this.unitOfMeasure2,
    required this.updatedAt,
    required this.updatedBy,
    required this.value1,
    required this.value2,
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{};
  }

  static Future<UnitOfMeasurementConversion> fromServer(Map<String, dynamic> jsonObject) async {
    late UnitOfMeasurementConversion conversion;

    await appStore.userApp.getUser(jsonObject["created_by_username"]).then((createdByResponse) async {
      await appStore.userApp.getUser(jsonObject["updated_by_username"]).then((updatedByResponse) async {
        await appStore.unitOfMeasurementApp.get(jsonObject["unit1_id"]).then((unit1Response) async {
          await appStore.unitOfMeasurementApp.get(jsonObject["unit2_id"]).then((unit2Response) async {
            conversion = UnitOfMeasurementConversion._(
              createdAt: DateTime.parse(jsonObject["created_at"]),
              createdBy: await User.fromServer(createdByResponse["payload"]),
              factoryID: jsonObject["factory_id"],
              id: jsonObject["id"],
              unitOfMeasure1: await UnitOfMeasure.fromServer(unit1Response["payload"]),
              unitOfMeasure2: await UnitOfMeasure.fromServer(unit2Response["payload"]),
              updatedAt: DateTime.parse(jsonObject["updated_at"]),
              updatedBy: await User.fromServer(updatedByResponse["payload"]),
              value1: double.parse(jsonObject["value1"].toString()),
              value2: double.parse(jsonObject["value2"].toString()),
            );
          });
        });
      });
    });

    return conversion;
  }
}
