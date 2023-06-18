import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/user.dart';

class Company {
  final String id;
  final String name;
  final bool active;
  final DateTime createdAt;
  final User createdBy;
  final DateTime updatedAt;
  final User updatedBy;

  Company._({
    required this.active,
    required this.createdAt,
    required this.createdBy,
    required this.id,
    required this.name,
    required this.updatedAt,
    required this.updatedBy,
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      "active": active,
      "created_at": createdAt,
      "created_by": createdBy.toJSON(),
      "id": id,
      "name": name,
      "updated_at": updatedAt,
      "updated_by": updatedBy.toJSON(),
    };
  }

  static Future<Company> fromServer(Map<String, dynamic> jsonObject) async {
    late Company company;

    await appStore.userApp.getUser(jsonObject["created_by_username"]).then((createdByResponse) async {
      await appStore.userApp.getUser(jsonObject["updated_by_username"]).then((updatedByResponse) async {
        company = Company._(
          active: jsonObject["active"],
          createdAt: DateTime.parse(jsonObject["created_at"]),
          createdBy: await User.fromServer(createdByResponse["payload"]),
          id: jsonObject["id"],
          name: jsonObject["name"],
          updatedAt: DateTime.parse(jsonObject["updated_at"]),
          updatedBy: await User.fromServer(updatedByResponse["payload"]),
        );
      });
    });

    return company;
  }
}
