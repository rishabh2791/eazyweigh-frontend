import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/factory.dart';
import 'package:eazyweigh/domain/entity/user.dart';

class Shift {
  final String id;
  final Factory fact;
  final String code;
  final String description;
  final String startTime;
  final String endTime;
  final DateTime createdAt;
  final User createdBy;
  final DateTime updatedAt;
  final User updatedBy;

  Shift._({
    required this.code,
    required this.createdAt,
    required this.createdBy,
    required this.description,
    required this.endTime,
    required this.fact,
    required this.id,
    required this.startTime,
    required this.updatedAt,
    required this.updatedBy,
  });

  @override
  String toString() {
    return fact.name + " - " + code;
  }

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      "code": code,
      "created_at": createdAt,
      "created_by": createdBy.toJSON(),
      "description": description,
      "end_time": endTime,
      "factory": fact,
      "id": id,
      "start_time": startTime,
      "updated_at": updatedAt,
      "updated_by": updatedBy.toJSON(),
    };
  }

  static Future<Shift> fromServer(Map<String, dynamic> jsonObject) async {
    late Shift shift;

    await appStore.userApp.getUser(jsonObject["created_by_username"]).then((createdByResponse) async {
      await appStore.userApp.getUser(jsonObject["updated_by_username"]).then((updatedByResponse) async {
        await appStore.factoryApp.get(jsonObject["factory_id"]).then((factoryResponse) async {
          shift = Shift._(
            code: jsonObject["code"],
            createdAt: DateTime.parse(jsonObject["created_at"]),
            createdBy: await User.fromServer(createdByResponse["payload"]),
            description: jsonObject["description"],
            endTime: jsonObject["end_time"],
            fact: await Factory.fromServer(factoryResponse["payload"]),
            id: jsonObject["id"],
            startTime: jsonObject["start_time"],
            updatedAt: DateTime.parse(jsonObject["updated_at"]),
            updatedBy: await User.fromServer(updatedByResponse["payload"]),
          );
        });
      });
    });

    return shift;
  }
}
