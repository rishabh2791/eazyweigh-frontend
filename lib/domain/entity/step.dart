import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/step_type.dart';
import 'package:eazyweigh/domain/entity/user.dart';

class Step {
  final String id;
  final StepType stepType;
  final String description;
  final String processID;
  String materialID;
  double value;
  int sequence;
  int duration;
  final User createdBy;
  final DateTime createdAt;
  final User updatedBy;
  final DateTime updatedAt;

  Step._({
    required this.createdAt,
    required this.createdBy,
    required this.description,
    this.duration = 0,
    required this.id,
    this.materialID = "",
    required this.processID,
    required this.sequence,
    required this.stepType,
    required this.updatedAt,
    required this.updatedBy,
    this.value = 0,
  });

  @override
  String toString() {
    return description;
  }

  Map<String, dynamic> toJSON() {
    return {
      "id": id,
      "step_type": stepType.toJSON(),
      "description": description,
      "duration": duration,
      "material_id": materialID,
      "value": value,
      "process_id": processID,
      "sequence": sequence,
      "created_at": createdAt,
      "created_by": createdBy.toJSON(),
      "updated_at": updatedAt,
      "updated_by": updatedBy.toJSON(),
    };
  }

  static Future<Step> fromServer(Map<String, dynamic> jsonObject) async {
    late Step step;

    await appStore.userApp.getUser(jsonObject["created_by_username"]).then((createdByResponse) async {
      await appStore.userApp.getUser(jsonObject["updated_by_username"]).then((updatedByResponse) async {
        Map<String, dynamic> conditions = {
          "EQUALS": {
            "Field": "id",
            "Value": jsonObject["step_type_id"],
          }
        };
        await appStore.stepTypeApp.list(conditions).then((stepTypeResponse) async {
          step = Step._(
            createdAt: DateTime.parse(jsonObject["created_at"]),
            createdBy: await User.fromServer(createdByResponse["payload"]),
            description: jsonObject["description"],
            id: jsonObject["id"],
            processID: jsonObject["process_id"],
            sequence: int.parse(jsonObject["sequence"].toString()),
            stepType: await StepType.fromServer(stepTypeResponse["payload"][0]),
            updatedAt: DateTime.parse(jsonObject["updated_at"]),
            updatedBy: await User.fromServer(updatedByResponse["payload"]),
            duration: int.parse(jsonObject["duration"].toString()),
            value: double.parse(jsonObject["value"].toString()),
            materialID: jsonObject["material_id"] ?? "",
          );
        });
      });
    });

    return step;
  }
}
