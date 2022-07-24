import 'package:eazyweigh/domain/entity/factory.dart';
import 'package:eazyweigh/domain/entity/user.dart';

class Vessel {
  final String id;
  final Factory fact;
  final String name;
  final User createdBy;
  final DateTime createdAt;
  final User updatedBy;
  final DateTime updatedAt;

  Vessel({
    required this.createdAt,
    required this.createdBy,
    required this.fact,
    required this.id,
    required this.name,
    required this.updatedAt,
    required this.updatedBy,
  });

  @override
  String toString() {
    return name;
  }

  Map<String, dynamic> toJSON() {
    return {
      "created_at": createdAt,
      "created_by": createdBy.toJSON(),
      "factory": fact.toJSON(),
      "id": id,
      "name": name,
      "updated_at": updatedAt,
      "updated_by": updatedBy.toJSON(),
    };
  }

  factory Vessel.fromJSON(Map<String, dynamic> jsonObject) {
    Vessel vessel = Vessel(
      createdAt: DateTime.parse(jsonObject["created_at"]),
      createdBy: User.fromJSON(jsonObject["created_by"]),
      fact: Factory.fromJSON(jsonObject["factory"]),
      id: jsonObject["id"],
      name: jsonObject["name"],
      updatedAt: DateTime.parse(jsonObject["updated_at"]),
      updatedBy: User.fromJSON(jsonObject["updated_by"]),
    );
    return vessel;
  }
}
