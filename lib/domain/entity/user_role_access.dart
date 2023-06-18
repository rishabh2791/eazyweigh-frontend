import 'package:eazyweigh/application/app_store.dart';
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

  UserRoleAccess._({
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

  static Future<UserRoleAccess> fromServer(Map<String, dynamic> jsonObject) async {
    late UserRoleAccess userRoleAccess;

    await appStore.userApp.getUser(jsonObject["created_by_username"]).then((createdByResponse) async {
      await appStore.userApp.getUser(jsonObject["updated_by_username"]).then((updatedByResponse) async {
        await appStore.userRoleApp.get(jsonObject["user_role_id"]).then((userRoleResponse) async {
          userRoleAccess = UserRoleAccess._(
            accessLevel: jsonObject["access_level"],
            createdAt: DateTime.parse(jsonObject["created_at"]),
            createdBy: await User.fromServer(createdByResponse["payload"]),
            tableName: jsonObject["table_name"],
            updatedAt: DateTime.parse(jsonObject["updated_at"]),
            updatedBy: await User.fromServer(updatedByResponse["payload"]),
            userRole: await UserRole.fromServer(userRoleResponse["payload"]),
          );
        });
      });
    });

    return userRoleAccess;
  }
}
