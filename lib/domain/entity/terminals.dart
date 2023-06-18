import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/unit_of_measure.dart';
import 'package:eazyweigh/domain/entity/user.dart';

class Terminal {
  final String id;
  final String description;
  final String factoryID;
  final String apiKey;
  final String macAddress;
  final double capacity;
  final UnitOfMeasure uom;
  final double leastCount;
  final bool occupied;
  final DateTime createdAt;
  final User createdBy;
  final DateTime updatedAt;
  final User updatedBy;

  Terminal._({
    required this.apiKey,
    required this.capacity,
    required this.createdAt,
    required this.createdBy,
    required this.description,
    required this.factoryID,
    required this.id,
    required this.leastCount,
    required this.macAddress,
    required this.occupied,
    required this.uom,
    required this.updatedAt,
    required this.updatedBy,
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      "api_key": apiKey,
      "capacity": capacity,
      "created_at": createdAt,
      "created_by": createdBy.toJSON(),
      "description": description,
      "factory_id": factoryID,
      "id": id,
      "least_count": leastCount,
      "mac_address": macAddress,
      "occupied": occupied,
      "unit_of_measure": uom.toJSON(),
      "updated_at": updatedAt,
      "updated_by": updatedBy.toJSON(),
    };
  }

  static Future<Terminal> fromServer(Map<String, dynamic> jsonObject) async {
    late Terminal terminal;

    await appStore.userApp.getUser(jsonObject["created_by_username"]).then((createdByResponse) async {
      await appStore.userApp.getUser(jsonObject["updated_by_username"]).then((updatedByResponse) async {
        await appStore.unitOfMeasurementApp.get(jsonObject["unit_of_measurement_id"]).then((uomResponse) async {
          terminal = Terminal._(
            apiKey: jsonObject["api_key"],
            capacity: double.parse(jsonObject["capacity"].toString()),
            createdAt: DateTime.parse(jsonObject["created_at"]),
            createdBy: await User.fromServer(createdByResponse["payload"]),
            description: jsonObject["description"],
            factoryID: jsonObject["factory_id"],
            id: jsonObject["id"],
            leastCount: double.parse(jsonObject["least_count"].toString()),
            macAddress: jsonObject["mac_address"],
            occupied: jsonObject["occupied"],
            uom: await UnitOfMeasure.fromServer(uomResponse["payload"]),
            updatedAt: DateTime.parse(jsonObject["updated_at"]),
            updatedBy: await User.fromServer(updatedByResponse["payload"]),
          );
        });
      });
    });

    return terminal;
  }
}
