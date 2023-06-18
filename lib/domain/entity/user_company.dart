import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/company.dart';
import 'package:eazyweigh/domain/entity/user.dart';

class UserCompany {
  final User user;
  final Company company;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserCompany._({
    required this.company,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      "company": company.toJSON(),
      "user": user.toJSON(),
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }

  static Future<UserCompany> fromServer(Map<String, dynamic> jsonObject) async {
    late UserCompany userCompany;

    await appStore.userApp.getUser(jsonObject["user_username"]).then((userResponse) async {
      await appStore.companyApp.get(jsonObject["company_id"]).then((companyResponse) async {
        userCompany = UserCompany._(
          company: await Company.fromServer(companyResponse["payload"]),
          user: await User.fromServer(userResponse["payload"]),
          createdAt: DateTime.parse(jsonObject["created_at"]),
          updatedAt: DateTime.parse(jsonObject["updated_at"]),
        );
      });
    });

    return userCompany;
  }
}
