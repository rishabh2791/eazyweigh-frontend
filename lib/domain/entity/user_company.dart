import 'package:eazyweigh/domain/entity/company.dart';
import 'package:eazyweigh/domain/entity/user.dart';

class UserCompany {
  final User user;
  final Company fact;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserCompany({
    required this.fact,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      "company": fact.toJSON(),
      "user": user.toJSON(),
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }

  factory UserCompany.fromJSON(Map<String, dynamic> jsonObject) {
    UserCompany userCompany = UserCompany(
      fact: Company.fromJSON(jsonObject["company"]),
      user: User.fromJSON(jsonObject["user"]),
      createdAt: DateTime.parse(jsonObject["created_at"]),
      updatedAt: DateTime.parse(jsonObject["updated_at"]),
    );
    return userCompany;
  }
}
