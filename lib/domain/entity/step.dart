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
  final User createdBy;
  final DateTime createdAt;
  final User updatedBy;
  final DateTime updatedAt;

  Step({
    required this.createdAt,
    required this.createdBy,
    required this.description,
    required this.id,
    required this.materialID,
    required this.processID,
    required this.sequence,
    required this.stepType,
    required this.updatedAt,
    required this.updatedBy,
    required this.value,
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
      id: jsonObject["id"],
      materialID: jsonObject["material_id"],
      processID: jsonObject["process_id"],
      sequence: jsonObject["sequence"],
      stepType: StepType.fromJSON(jsonObject["step_type"]),
      updatedAt: DateTime.parse(jsonObject["updated_at"]).toLocal(),
      updatedBy: User.fromJSON(jsonObject["updated_by"]),
      value: jsonObject["value"],
    );
    return step;
  }
}
