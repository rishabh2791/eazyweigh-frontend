import 'package:eazyweigh/domain/entity/user_role.dart';

class User {
  final String username;
  final String password;
  final String firstName;
  final String lastName;
  final String email;
  final UserRole userRole;
  final bool active;
  final String createdByUsername;
  final DateTime createdAt;
  final String updatedByUsername;
  final DateTime updatedAt;

  User({
    required this.active,
    required this.createdAt,
    required this.createdByUsername,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.updatedAt,
    required this.updatedByUsername,
    required this.userRole,
    required this.username,
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      "active": active,
      "created_at": createdAt,
      "created_by)username": createdByUsername,
      "email": email,
      "first_name": firstName,
      "last_name": lastName,
      "password": password,
      "updated_at": updatedAt,
      "updated_by_username": updatedByUsername,
      "user_role": userRole,
      "username": username,
    };
  }

  factory User.fromJSON(Map<String, dynamic> jsonObject) {
    User user = User(
      active: jsonObject["active"],
      createdAt: DateTime.parse(jsonObject["created_at"]),
      createdByUsername: jsonObject["created_by_username"],
      email: jsonObject["email"],
      firstName: jsonObject["first_name"],
      lastName: jsonObject["last_name"],
      password: jsonObject["password"],
      updatedAt: DateTime.parse(jsonObject["updated_at"]),
      updatedByUsername: jsonObject["updated_by_username"],
      userRole: UserRole.fromJSON(jsonObject["user_role"]),
      username: jsonObject["username"],
    );
    return user;
  }
}
