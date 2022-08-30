import 'package:eazyweigh/domain/entity/unit_of_measure.dart';
import 'package:eazyweigh/domain/entity/user.dart';

class Mat {
  final String id; //done
  final String code; //done
  final String description; //done
  final String type; //done
  final String factoryID; //
  final UnitOfMeasure uom; //
  final DateTime createdAt; //
  final User createdBy; //
  final DateTime updatedAt; //
  final User updatedBy; //
  final bool isWeighed;

  Mat({
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
    required this.isWeighed,
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      "id": id,
      "code": code,
      "description": description,
      "type": type,
      "factory_id": factoryID,
      "unit_of_measurement": uom.toJSON(),
      "created_at": createdAt,
      "created_by": createdBy.toJSON(),
      "updated_at": updatedAt,
      "updated_by": updatedBy.toJSON(),
      "is_weighed": isWeighed,
    };
  }

  factory Mat.fromJSON(Map<String, dynamic> jsonObject) {
    Mat material = Mat(
      code: jsonObject["code"],
      createdAt: DateTime.parse(jsonObject["created_at"]).toLocal(),
      createdBy: User.fromJSON(jsonObject["created_by"]),
      description: jsonObject["description"],
      factoryID: jsonObject["factory_id"],
      id: jsonObject["id"],
      type: jsonObject["type"],
      uom: UnitOfMeasure.fromJSON(jsonObject["unit_of_measurement"]),
      updatedAt: DateTime.parse(jsonObject["updated_at"]).toLocal(),
      updatedBy: User.fromJSON(jsonObject["updated_by"]),
      isWeighed: jsonObject["is_weighed"],
    );
    return material;
  }
}
