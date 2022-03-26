import 'package:eazyweigh/domain/entity/factory.dart';
import 'package:eazyweigh/domain/entity/user.dart';

class UnitOfMeasure {
  final String id;
  final Factory fact;
  final String code;
  final String description;
  final DateTime createdAt;
  final User createdBy;
  final DateTime updatedAt;
  final User updatedBy;

  UnitOfMeasure({
    required this.code,
    required this.createdAt,
    required this.createdBy,
    required this.description,
    required this.fact,
    required this.id,
    required this.updatedAt,
    required this.updatedBy,
  });

  @override
  String toString() {
    return code;
  }

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      "code": code,
      "created_at": createdAt,
      "created_by": createdBy.toJSON(),
      "description": description,
      "factory": fact,
      "id": id,
      "updated_at": updatedAt,
      "updated_by": updatedBy.toJSON(),
    };
  }

  factory UnitOfMeasure.fromJSON(Map<String, dynamic> jsonObject) {
    UnitOfMeasure uom = UnitOfMeasure(
      code: jsonObject["code"],
      createdAt: DateTime.parse(jsonObject["created_at"]),
      createdBy: User.fromJSON(jsonObject["created_by"]),
      description: jsonObject["description"],
      fact: Factory.fromJSON(jsonObject["factory"]),
      id: jsonObject["id"],
      updatedAt: DateTime.parse(jsonObject["updated_at"]),
      updatedBy: User.fromJSON(jsonObject["updated_by"]),
    );
    return uom;
  }
}
