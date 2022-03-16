import 'package:eazyweigh/domain/entity/material.dart';
import 'package:eazyweigh/domain/entity/unit_of_measure.dart';
import 'package:eazyweigh/domain/entity/user.dart';

class BOM {
  final String id;
  final Material material;
  final int revision;
  final UnitOfMeasure uom;
  final double unitSize;
  final DateTime createdAt;
  final User createdBy;
  final DateTime updatedAt;
  final User updatedBy;

  BOM({
    required this.createdAt,
    required this.createdBy,
    required this.id,
    required this.material,
    required this.revision,
    required this.unitSize,
    required this.uom,
    required this.updatedAt,
    required this.updatedBy,
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      "created_at": createdAt,
      "created_by": createdBy,
      "id": id,
      "revision": revision,
      "material": material.toJSON(),
      "unit_size": unitSize,
      "unit_of_measure": uom.toJSON(),
      "updated_at": updatedAt,
      "updated_by": updatedBy,
    };
  }

  factory BOM.fromJSON(Map<String, dynamic> jsonObject) {
    BOM bom = BOM(
      createdAt: DateTime.parse(jsonObject["created_at"]),
      createdBy: User.fromJSON(jsonObject["created_at"]),
      id: jsonObject["id"],
      material: Material.fromJSON(jsonObject["material"]),
      revision: jsonObject["revision"],
      unitSize: jsonObject["unit_size"],
      uom: UnitOfMeasure.fromJSON(jsonObject["unit_of_measure"]),
      updatedAt: DateTime.parse(jsonObject["updated_at"]),
      updatedBy: jsonObject["updated_by"],
    );
    return bom;
  }
}
