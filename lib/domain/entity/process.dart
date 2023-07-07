import 'package:eazyweigh/domain/entity/material.dart';
import 'package:eazyweigh/domain/entity/step.dart';
import 'package:eazyweigh/domain/entity/user.dart';

class Process {
  final String id;
  final Mat material;
  final int version;
  List<Step> steps;
  final User createdBy;
  final DateTime createdAt;
  final User updatedBy;
  final DateTime updatedAt;

  Process({
    required this.createdAt,
    required this.createdBy,
    required this.material,
    required this.version,
    required this.id,
    this.steps = const [],
    required this.updatedAt,
    required this.updatedBy,
  });

  @override
  String toString() {
    return material.code + " - " + material.description;
  }

  Map<String, dynamic> toJSON() {
    List<Map<String, dynamic>> processSteps = [];
    for (var thisStep in steps) {
      processSteps.add(thisStep.toJSON());
    }
    return {
      "created_at": createdAt,
      "created_by": createdBy.toJSON(),
      "material": material.toJSON(),
      "version": version,
      "id": id,
      "steps": processSteps,
      "updated_at": updatedAt,
      "updated_by": updatedBy.toJSON(),
    };
  }

  factory Process.fromJSON(Map<String, dynamic> jsonObject) {
    List<Step> steps = [];
    if (jsonObject["steps"].isNotEmpty) {
      for (var data in jsonObject["steps"]) {
        Step thisStep = Step.fromJSON(data);
        steps.add(thisStep);
      }
    }
    steps.sort((a, b) => a.sequence.compareTo(b.sequence));
    Process process = Process(
      createdAt: DateTime.parse(jsonObject["created_at"]),
      createdBy: User.fromJSON(jsonObject["created_by"]),
      material: Mat.fromJSON(jsonObject["material"]),
      id: jsonObject["id"],
      steps: steps,
      updatedAt: DateTime.parse(jsonObject["updated_at"]),
      updatedBy: User.fromJSON(jsonObject["updated_by"]),
      version: jsonObject["version"],
    );
    return process;
  }
}
