import 'package:eazyweigh/application/app_store.dart';
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

  Process._({
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

  static Future<Process> fromServer(Map<String, dynamic> jsonObject) async {
    late Process process;

    await appStore.userApp.getUser(jsonObject["created_by_username"]).then((createdByResponse) async {
      await appStore.userApp.getUser(jsonObject["updated_by_username"]).then((updatedByResponse) async {
        await appStore.materialApp.get(jsonObject["material_id"]).then((materialResponse) async {
          Map<String, dynamic> conditions = {
            "EQUALS": {
              "Field": "process_id",
              "Value": jsonObject["process_id"],
            }
          };
          List<Step> steps = [];
          await appStore.stepApp.list(conditions).then((stepResponse) async {
            for (var item in stepResponse["payload"]) {
              Step currentStep = await Step.fromServer(item);
              steps.add(currentStep);
            }
            process = Process._(
              createdAt: DateTime.parse(jsonObject["created_at"]),
              createdBy: await User.fromServer(jsonObject["created_at"]),
              material: await Mat.fromServer(materialResponse["payload"]),
              version: int.parse(jsonObject["version"].toString()),
              id: jsonObject["id"],
              updatedAt: DateTime.parse(jsonObject["updated_at"]),
              updatedBy: await User.fromServer(updatedByResponse["payload"]),
              steps: steps,
            );
          });
        });
      });
    });

    return process;
  }
}
