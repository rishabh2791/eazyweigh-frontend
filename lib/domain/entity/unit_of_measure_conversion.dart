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

  UnitOfMeasurementConversion({
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

  factory UnitOfMeasurementConversion.fromJSON(Map<String, dynamic> jsonObject) {
    UnitOfMeasurementConversion unitOfMeasurementConversion = UnitOfMeasurementConversion(
      createdAt: DateTime.parse(jsonObject["created_at"]).toLocal(),
      createdBy: User.fromJSON(jsonObject["created_by"]),
      factoryID: jsonObject["factory_id"],
      id: jsonObject["id"],
      unitOfMeasure1: UnitOfMeasure.fromJSON(jsonObject["unit1"]),
      unitOfMeasure2: UnitOfMeasure.fromJSON(jsonObject["unit2"]),
      updatedAt: DateTime.parse(jsonObject["updated_at"]).toLocal(),
      updatedBy: User.fromJSON(jsonObject["updated_by"]),
      value1: double.parse(jsonObject["value1"].toString()),
      value2: double.parse(jsonObject["value2"].toString()),
    );
    return unitOfMeasurementConversion;
  }
}
