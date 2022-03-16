import 'package:eazyweigh/domain/entity/material.dart';
import 'package:eazyweigh/domain/entity/unit_of_measure.dart';
import 'package:eazyweigh/domain/entity/user.dart';

class BomItem {
  final String id;
  final String bomID;
  final Material material;
  final double quantity;
  final double tolerance;
  final bool overIssue;
  final bool underIssue;
  final UnitOfMeasure uom;
  final DateTime createdAt;
  final User createdBy;
  final DateTime updatedAt;
  final User updatedBy;

  BomItem({
    required this.bomID,
    required this.createdAt,
    required this.createdBy,
    required this.id,
    required this.material,
    required this.overIssue,
    required this.quantity,
    required this.tolerance,
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
      "tolerance": tolerance,
      "under_issue": underIssue,
      "unit_of_measurement": uom.toJSON(),
      "updated_at": updatedAt,
      "updated_by": updatedBy,
    };
  }

  factory BomItem.fromJSON(Map<String, dynamic> jsonObject) {
    BomItem bomItem = BomItem(
      bomID: jsonObject["bom_id"],
      createdAt: DateTime.parse(jsonObject["created_at"]),
      createdBy: User.fromJSON(jsonObject["created_by"]),
      id: jsonObject["id"],
      material: Material.fromJSON(jsonObject["material"]),
      overIssue: jsonObject["over_issue"],
      quantity: jsonObject["quantity"],
      tolerance: jsonObject["tolerance"],
      underIssue: jsonObject["under_issue"],
      uom: UnitOfMeasure.fromJSON(jsonObject["unit_of_measure"]),
      updatedAt: DateTime.parse(jsonObject["udpated_at"]),
      updatedBy: User.fromJSON(jsonObject["updated_by"]),
    );
    return bomItem;
  }
}
