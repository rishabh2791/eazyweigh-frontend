import 'package:eazyweigh/domain/entity/user.dart';

class UserRoleAccess {
  final String userRoleRole;
  final String tableName;
  final String accessLevel;
  final DateTime createdAt;
  final User createdBy;
  final DateTime updatedAt;
  final User updatedBy;

  UserRoleAccess({
    required this.accessLevel,
    required this.createdAt,
    required this.createdBy,
    required this.tableName,
    required this.updatedAt,
    required this.updatedBy,
    required this.userRoleRole,
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      "user_role_role": userRoleRole,
      "table_name": tableName,
      "access_level": accessLevel,
      "created_at": createdAt,
      "created_by": createdBy.toJSON(),
      "updated_at": updatedAt,
      "updated_by": updatedBy.toJSON(),
    };
  }

  factory UserRoleAccess.fromJSON(Map<String, dynamic> jsonObject) {
    UserRoleAccess userRoleAccess = UserRoleAccess(
      accessLevel: jsonObject["access_level"],
      createdAt: DateTime.parse(jsonObject["created_at"]),
      createdBy: User.fromJSON(jsonObject["created_by"]),
      tableName: jsonObject["table_name"],
      updatedAt: DateTime.parse(jsonObject["updated_at"]),
      updatedBy: User.fromJSON(jsonObject["updated_by"]),
      userRoleRole: jsonObject["user_role_role"],
    );
    return userRoleAccess;
  }
}
