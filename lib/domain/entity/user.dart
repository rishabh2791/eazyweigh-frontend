import 'package:eazyweigh/domain/entity/company.dart';
import 'package:eazyweigh/domain/entity/user_role.dart';

class User {
  final String username;
  final String password;
  final String firstName;
  final String lastName;
  final String email;
  final UserRole userRole;
  final String secretKey;
  final bool superuser;
  final Company company;
  final bool active;
  final User createdBy;
  final DateTime createdAt;
  final User updatedBy;
  final DateTime updatedAt;

  User({
    required this.active,
    required this.company,
    required this.createdAt,
    required this.createdBy,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.secretKey,
    required this.superuser,
    required this.updatedAt,
    required this.updatedBy,
    required this.userRole,
    required this.username,
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      "active": active,
      "company": company.toJSON(),
      "created_at": createdAt,
      "created_by": createdBy.toJSON(),
      "email": email,
      "first_name": firstName,
      "last_name": lastName,
      "password": password,
      "secret_key": secretKey,
      "superuser": superuser,
      "updated_at": updatedAt,
      "updated_by": updatedBy.toJSON(),
      "user_role": userRole.toJSON(),
      "username": username,
    };
  }

  factory User.fromJSON(Map<String, dynamic> jsonObject) {
    User user = User(
      active: jsonObject["active"],
      company: Company.fromJSON(jsonObject["company"]),
      createdAt: DateTime.parse(jsonObject["created_at"]),
      createdBy: User.fromJSON(
        jsonObject["created_by"],
      ),
      email: jsonObject["email"],
      firstName: jsonObject["first_name"],
      lastName: jsonObject["last_name"],
      password: jsonObject["password"],
      secretKey: jsonObject["secret_key"],
      superuser: jsonObject["superuser"],
      updatedAt: DateTime.parse(jsonObject["updated_at"]),
      updatedBy: User.fromJSON(jsonObject["updated_by"]),
      userRole: UserRole.fromJSON(jsonObject["user_role"]),
      username: jsonObject["username"],
    );
    return user;
  }
}
