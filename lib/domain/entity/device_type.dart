import 'package:eazyweigh/domain/entity/factory.dart';
import 'package:eazyweigh/domain/entity/user.dart';

class DeviceType {
  final String id;
  final Factory fact;
  String description;
  final User createdBy;
  final DateTime createdAt;
  final User updatedBy;
  final DateTime updatedAt;

  DeviceType({
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
    return description;
  }

  Map<String, dynamic> toJSON() {
    return {
      "created_at": createdAt,
      "created_by": createdBy.toJSON(),
      "id": id,
      "description": description,
      "updated_at": updatedAt,
      "updated_by": updatedBy.toJSON(),
      "factory": fact.toJSON(),
    };
  }

  factory DeviceType.fromJSON(Map<String, dynamic> jsonObject) {
    DeviceType device = DeviceType(
      createdAt: DateTime.parse(jsonObject["created_at"]),
      createdBy: User.fromJSON(jsonObject["created_by"]),
      id: jsonObject["id"],
      description: jsonObject["description"],
      updatedAt: DateTime.parse(jsonObject["updated_at"]),
      updatedBy: User.fromJSON(jsonObject["updated_by"]),
      fact: Factory.fromJSON(jsonObject["factory"]),
    );
    return device;
  }
}
