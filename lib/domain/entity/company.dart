import 'package:eazyweigh/domain/entity/user.dart';

class Company {
  final int id;
  final String name;
  final bool active;
  final DateTime createdAt;
  final User createdBy;
  final DateTime updatedAt;
  final User updatedBy;

  Company({
    required this.active,
    required this.createdAt,
    required this.createdBy,
    required this.id,
    required this.name,
    required this.updatedAt,
    required this.updatedBy,
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      "active": active,
      "created_at": createdAt,
      "created_by": createdBy.toJSON(),
      "id": id,
      "name": name,
      "updated_at": updatedAt,
      "updated_by": updatedBy.toJSON(),
    };
  }

  factory Company.fromJSON(Map<String, dynamic> jsonObject) {
    Company company = Company(
      active: jsonObject["active"],
      createdAt: DateTime.parse(jsonObject["created_at"]),
      createdBy: User.fromJSON(jsonObject["created_by"]),
      id: jsonObject["id"],
      name: jsonObject["name"],
      updatedAt: DateTime.parse(jsonObject["updated_at"]),
      updatedBy: User.fromJSON(jsonObject["updated_by"]),
    );
    return company;
  }
}
