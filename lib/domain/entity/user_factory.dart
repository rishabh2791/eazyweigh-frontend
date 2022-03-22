import 'package:eazyweigh/domain/entity/factory.dart';
import 'package:eazyweigh/domain/entity/user.dart';

class UserFactory {
  final User user;
  final Factory fact;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserFactory({
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

  factory UserFactory.fromJSON(Map<String, dynamic> jsonObject) {
    UserFactory userFactory = UserFactory(
      fact: Factory.fromJSON(jsonObject["factory"]),
      user: User.fromJSON(jsonObject["user"]),
      createdAt: DateTime.parse(jsonObject["created_at"]),
      updatedAt: DateTime.parse(jsonObject["updated_at"]),
    );
    return userFactory;
  }
}
