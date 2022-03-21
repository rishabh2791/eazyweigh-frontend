class UserRole {
  final String role;
  final String description;
  final String companyID;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserRole({
    required this.active,
    this.companyID = "",
    required this.createdAt,
    required this.description,
    required this.role,
    required this.updatedAt,
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      "active": active,
      "company_id": companyID,
      "created_at": createdAt,
      "description": description,
      "role": role,
      "updated_at": updatedAt,
    };
  }

  factory UserRole.fromJSON(Map<String, dynamic> jsonObject) {
    UserRole userRole = UserRole(
      active: jsonObject["active"],
      companyID: jsonObject["company_id"],
      createdAt: DateTime.parse(jsonObject["created_at"]),
      description: jsonObject["description"],
      role: jsonObject["role"],
      updatedAt: DateTime.parse(jsonObject["updated_at"]),
    );
    return userRole;
  }
}
