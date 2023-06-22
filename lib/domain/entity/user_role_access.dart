import 'package:eazyweigh/domain/entity/user.dart';
import 'package:eazyweigh/domain/entity/user_role.dart';

class UserRoleAccess {
  final UserRole userRole;
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
    required this.userRole,
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      "user_role": userRole.toJSON(),
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
      createdAt: DateTime.parse(jsonObject["created_at"]).toLocal(),
      createdBy: User.fromJSON(jsonObject["created_by"]),
      tableName: jsonObject["table_name"],
      updatedAt: DateTime.parse(jsonObject["updated_at"]).toLocal(),
      updatedBy: User.fromJSON(jsonObject["updated_by"]),
      userRole: UserRole.fromJSON(jsonObject["user_role_role"]),
    );
    return userRoleAccess;
  }
}
