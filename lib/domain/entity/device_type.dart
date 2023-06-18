import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/factory.dart';
import 'package:eazyweigh/domain/entity/user.dart';

class DeviceType {
  final String id;
  final Factory fact;
  String description;
  final User createdBy;
  final DateTime createdAt;
  final User updatedBy;
  final DateTime updatedAt;

  DeviceType._({
    required this.createdAt,
    required this.createdBy,
    required this.description,
    required this.fact,
    required this.id,
    required this.updatedAt,
    required this.updatedBy,
  });

  @override
  String toString() {
    return description;
  }

  Map<String, dynamic> toJSON() {
    return {
      "created_at": createdAt,
      "created_by": createdBy.toJSON(),
      "id": id,
      "description": description,
      "updated_at": updatedAt,
      "updated_by": updatedBy.toJSON(),
      "factory": fact.toJSON(),
    };
  }

  static Future<DeviceType> fromServer(Map<String, dynamic> jsonObject) async {
    late DeviceType deviceType;

    await appStore.userApp.getUser(jsonObject["created_by_username"]).then((createdByResponse) async {
      await appStore.userApp.getUser(jsonObject["updated_by_username"]).then((updatedByResponse) async {
        await appStore.factoryApp.get(jsonObject["factory_id"]).then((factoryResponse) async {
          deviceType = DeviceType._(
            createdAt: DateTime.parse(jsonObject["created_at"]),
            createdBy: await User.fromServer(createdByResponse["payload"]),
            description: jsonObject["description"],
            fact: await Factory.fromServer(factoryResponse["payload"]),
            id: jsonObject["id"],
            updatedAt: DateTime.parse(jsonObject["updated_at"]),
            updatedBy: await User.fromServer(updatedByResponse["payload"]),
          );
        });
      });
    });

    return deviceType;
  }
}
