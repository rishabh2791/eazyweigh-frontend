import 'package:eazyweigh/domain/entity/company.dart';

class UserRole {
  final String role;
  final String description;
  final Company company;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserRole({
    required this.active,
    required this.company,
    required this.createdAt,
    required this.description,
    required this.role,
    required this.updatedAt,
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      "active": active,
      "company": company.toJSON(),
      "created_at": createdAt,
      "description": description,
      "role": role,
      "updated_at": updatedAt,
    };
  }

  factory UserRole.fromJSON(Map<String, dynamic> jsonObject) {
    UserRole userRole = UserRole(
      active: jsonObject["active"],
      company: Company.fromJSON(jsonObject["company"]),
      createdAt: DateTime.parse(jsonObject["created_at"]),
      description: jsonObject["description"],
      role: jsonObject["role"],
      updatedAt: DateTime.parse(jsonObject["updated_at"]),
    );
    return userRole;
  }
}
