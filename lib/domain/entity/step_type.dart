import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/factory.dart';
import 'package:eazyweigh/domain/entity/user.dart';

class StepType {
  final String id;
  final Factory fact;
  String name;
  final User createdBy;
  final DateTime createdAt;
  final User updatedBy;
  final DateTime updatedAt;
  String title;
  String body;
  String footer;

  StepType._({
    required this.createdAt,
    required this.createdBy,
    required this.fact,
    required this.id,
    required this.name,
    required this.updatedAt,
    required this.updatedBy,
    required this.body,
    required this.footer,
    required this.title,
  });

  @override
  String toString() {
    return name;
  }

  Map<String, dynamic> toJSON() {
    return {
      "created_at": createdAt,
      "created_by": createdBy.toJSON(),
      "factory": fact.toJSON(),
      "id": id,
      "name": name,
      "updated_at": updatedAt,
      "updated_by": updatedBy.toJSON(),
      "title": title,
      "body": body,
      "footer": footer,
    };
  }

  static Future<StepType> fromServer(Map<String, dynamic> jsonObject) async {
    late StepType stepType;

    await appStore.userApp.getUser(jsonObject["created_by_username"]).then((createdByResponse) async {
      await appStore.userApp.getUser(jsonObject["updated_by_username"]).then((updatedByResponse) async {
        await appStore.factoryApp.get(jsonObject["factory_id"]).then((factoryResponse) async {
          stepType = StepType._(
            createdAt: DateTime.parse(jsonObject["created_at"]),
            createdBy: await User.fromServer(createdByResponse["payload"]),
            fact: await Factory.fromServer(factoryResponse["payload"]),
            id: jsonObject["id"],
            name: jsonObject["description"],
            updatedAt: DateTime.parse(jsonObject["updated_at"]),
            updatedBy: await User.fromServer(updatedByResponse["payload"]),
            body: jsonObject["body"],
            footer: jsonObject["footer"],
            title: jsonObject["title"],
          );
        });
      });
    });

    return stepType;
  }
}
