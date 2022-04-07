import 'package:eazyweigh/domain/entity/user.dart';

class JobItemWeighing {
  final String id;
  final String jobItemID;
  final double weight;
  final DateTime startTime;
  final DateTime endTime;
  final User createdBy;
  final DateTime createdAt;
  final User updatedBy;
  final DateTime updatedAt;

  JobItemWeighing({
    required this.createdAt,
    required this.createdBy,
    required this.endTime,
    required this.id,
    required this.jobItemID,
    required this.startTime,
    required this.updatedAt,
    required this.updatedBy,
    required this.weight,
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      "id": id,
      "job_item_id": jobItemID,
      "weight": weight,
      "start_time": startTime,
      "end_time": endTime,
      "created_by": createdBy.toJSON(),
      "created_at": createdAt,
      "updated_by": updatedBy.toJSON(),
      "updated_at": updatedAt,
    };
  }

  factory JobItemWeighing.fromJSON(Map<String, dynamic> jsonObject) {
    JobItemWeighing jobItemWeighing = JobItemWeighing(
      createdAt: DateTime.parse(jsonObject["created_at"]),
      createdBy: User.fromJSON(jsonObject["created_by"]),
      endTime: DateTime.parse(jsonObject["end_time"]),
      id: jsonObject["id"],
      jobItemID: jsonObject["job_item_id"],
      startTime: DateTime.parse(jsonObject["start_time"]),
      updatedAt: DateTime.parse(jsonObject["updated_at"]),
      updatedBy: User.fromJSON(jsonObject["updated_by"]),
      weight: jsonObject["weight"],
    );
    return jobItemWeighing;
  }
}
