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

  Shift({
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

  factory Shift.fromJSON(Map<String, dynamic> jsonObject) {
    Shift shift = Shift(
      code: jsonObject["code"],
      createdAt: DateTime.parse(jsonObject["created_at"]),
      createdBy: User.fromJSON(jsonObject["created_by"]),
      description: jsonObject["description"],
      endTime: jsonObject["end_time"],
      fact: Factory.fromJSON(jsonObject["factory"]),
      id: jsonObject["id"],
      startTime: jsonObject["start_time"],
      updatedAt: DateTime.parse(jsonObject["updated_at"]),
      updatedBy: User.fromJSON(jsonObject["updated_by"]),
    );
    return shift;
  }
}
