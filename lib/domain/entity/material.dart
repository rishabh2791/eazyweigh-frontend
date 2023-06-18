import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/unit_of_measure.dart';
import 'package:eazyweigh/domain/entity/user.dart';

class Mat {
  final String id; //done
  final String code; //done
  final String description; //done
  final String type; //done
  final String factoryID; //
  final UnitOfMeasure uom; //
  final DateTime createdAt; //
  final User createdBy; //
  final DateTime updatedAt; //
  final User updatedBy; //
  final bool isWeighed;

  Mat._({
    required this.code,
    required this.createdAt,
    required this.createdBy,
    required this.description,
    required this.factoryID,
    required this.id,
    required this.type,
    required this.uom,
    required this.updatedAt,
    required this.updatedBy,
    required this.isWeighed,
  });

  @override
  String toString() {
    return code + " - " + description;
  }

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      "id": id,
      "code": code,
      "description": description,
      "type": type,
      "factory_id": factoryID,
      "unit_of_measurement": uom.toJSON(),
      "created_at": createdAt,
      "created_by": createdBy.toJSON(),
      "updated_at": updatedAt,
      "updated_by": updatedBy.toJSON(),
      "is_weighed": isWeighed,
    };
  }

  static Future<Mat> fromServer(Map<String, dynamic> jsonObject) async {
    late Mat mat;

    await appStore.userApp.getUser(jsonObject["created_by_username"]).then((createdByResponse) async {
      await appStore.userApp.getUser(jsonObject["updated_by_username"]).then((updatedByResponse) async {
        await appStore.unitOfMeasurementApp.get(jsonObject["unit_of_measurement_id"]).then((uomResponse) async {
          mat = Mat._(
            code: jsonObject["code"],
            createdAt: DateTime.parse(jsonObject["created_at"]),
            createdBy: await User.fromServer(createdByResponse["payload"]),
            description: jsonObject["description"],
            factoryID: jsonObject["factory_id"],
            id: jsonObject["id"],
            type: jsonObject["type"],
            uom: await UnitOfMeasure.fromServer(uomResponse["payload"]),
            updatedAt: DateTime.parse(jsonObject["updated_at"]),
            updatedBy: await User.fromServer(updatedByResponse["payload"]),
            isWeighed: jsonObject["is_weighed"],
          );
        });
      });
    });

    return mat;
  }
}
