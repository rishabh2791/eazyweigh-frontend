import 'package:eazyweigh/domain/entity/unit_of_measure.dart';
import 'package:eazyweigh/domain/entity/user.dart';

class Mat {
  final String id; //done
  final String code; //done
  final String description; //done
  final String type; //done
  final String factoryID; //done
  final String barCode; //
  final UnitOfMeasure uom; //
  final DateTime createdAt; //
  final User createdBy; //
  final DateTime updatedAt; //
  final User updatedBy; //

  Mat({
    required this.barCode,
    required this.code,
    required this.createdAt,
    required this.createdBy,
    required this.description,
    required this.factoryID,
    required this.id,
    required this.type,
    required this.uom,
    required this.updatedAt,
    required this.updatedBy,
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{};
  }

  factory Mat.fromJSON(Map<String, dynamic> jsonObject) {
    Mat material = Mat(
      barCode: jsonObject["bar_code"],
      code: jsonObject["code"],
      createdAt: DateTime.parse(jsonObject["created_at"]),
      createdBy: User.fromJSON(jsonObject["created_by"]),
      description: jsonObject["description"],
      factoryID: jsonObject["factory_id"],
      id: jsonObject["id"],
      type: jsonObject["type"],
      uom: UnitOfMeasure.fromJSON(jsonObject["unit_of_measurement"]),
      updatedAt: DateTime.parse(jsonObject["updated_at"]),
      updatedBy: User.fromJSON(jsonObject["updated_by"]),
    );
    return material;
  }
}
