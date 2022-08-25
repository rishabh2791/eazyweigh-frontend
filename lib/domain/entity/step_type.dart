import 'package:eazyweigh/domain/entity/factory.dart';
import 'package:eazyweigh/domain/entity/user.dart';

class StepType {
  final String id;
  final Factory fact;
  String name;
  final User createdBy;
  final DateTime createdAt;
  final User updatedBy;
  final DateTime updatedAt;

  StepType({
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

  factory StepType.fromJSON(Map<String, dynamic> jsonObject) {
    StepType stepType = StepType(
      createdAt: DateTime.parse(jsonObject["created_at"]),
      createdBy: User.fromJSON(jsonObject["created_by"]),
      fact: Factory.fromJSON(jsonObject["factory"]),
      id: jsonObject["id"],
      name: jsonObject["description"],
      updatedAt: DateTime.parse(jsonObject["updated_at"]),
      updatedBy: User.fromJSON(jsonObject["updated_by"]),
    );
    return stepType;
  }
}
