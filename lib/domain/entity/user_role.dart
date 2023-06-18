class UserRole {
  final String id;
  final String role;
  final String description;
  final String companyID;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool selected = false;

  UserRole._({
    required this.id,
    required this.active,
    this.companyID = "",
    required this.createdAt,
    required this.description,
    required this.role,
    required this.updatedAt,
  });

  @override
  String toString() {
    return role;
  }

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      "id": id,
      "active": active,
      "company_id": companyID,
      "created_at": createdAt,
      "description": description,
      "role": role,
      "updated_at": updatedAt,
    };
  }

  static Future<UserRole> fromServer(Map<String, dynamic> jsonObject) async {
    UserRole userRole;

    userRole = UserRole._(
      id: jsonObject["id"],
      active: jsonObject["active"],
      createdAt: DateTime.parse(jsonObject["created_at"]),
      description: jsonObject["description"],
      role: jsonObject["role"],
      updatedAt: DateTime.parse(jsonObject["updated_at"]),
      companyID: jsonObject["company_id"],
    );

    return userRole;
  }
}
