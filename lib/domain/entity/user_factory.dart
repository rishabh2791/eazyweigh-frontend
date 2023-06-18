import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/factory.dart';
import 'package:eazyweigh/domain/entity/user.dart';

class UserFactory {
  final User user;
  final Factory fact;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserFactory._({
    required this.fact,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      "factory": fact.toJSON(),
      "user": user.toJSON(),
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }

  static Future<UserFactory> fromServer(Map<String, dynamic> jsonObject) async {
    late UserFactory userFactory;

    await appStore.userApp.getUser(jsonObject["user_username"]).then((userResponse) async {
      await appStore.factoryApp.get(jsonObject["factory_id"]).then((factoryResponse) async {
        userFactory = UserFactory._(
          fact: await Factory.fromServer(factoryResponse["payload"]),
          user: await User.fromServer(userResponse["payload"]),
          createdAt: DateTime.parse(jsonObject["created_at"]),
          updatedAt: DateTime.parse(jsonObject["updated_at"]),
        );
      });
    });

    return userFactory;
  }
}
