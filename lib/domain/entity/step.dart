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

  Step({
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

  factory Step.fromJSON(Map<String, dynamic> jsonObject) {
    Step step = Step(
      createdAt: DateTime.parse(jsonObject["created_at"]).toLocal(),
      createdBy: User.fromJSON(jsonObject["created_by"]),
      description: jsonObject["description"],
      duration: jsonObject.containsKey("duration") && jsonObject["duration"].toString().isNotEmpty ? int.parse(jsonObject["duration"].toString()) : 0,
      id: jsonObject["id"],
      materialID: jsonObject.containsKey("material_id") && jsonObject["material_id"].toString().isNotEmpty ? jsonObject["material_id"] : "",
      processID: jsonObject["process_id"],
      sequence: int.parse(jsonObject["sequence"].toString()),
      stepType: StepType.fromJSON(jsonObject["step_type"]),
      updatedAt: DateTime.parse(jsonObject["updated_at"]).toLocal(),
      updatedBy: User.fromJSON(jsonObject["updated_by"]),
      value: jsonObject.containsKey("value") && jsonObject["value"].toString().isNotEmpty ? double.parse(jsonObject["value"].toString()) : 0,
    );
    return step;
  }
}
