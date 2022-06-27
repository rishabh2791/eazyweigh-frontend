import 'package:eazyweigh/domain/entity/job_item.dart';
import 'package:eazyweigh/domain/entity/user.dart';

class JobItemWeighing {
  final String id;
  final JobItem jobItem;
  final double weight;
  final String batch;
  final DateTime startTime;
  final DateTime endTime;
  final User createdBy;
  final DateTime createdAt;
  final User updatedBy;
  final DateTime updatedAt;
  bool verified;

  JobItemWeighing({
    required this.createdAt,
    required this.createdBy,
    required this.endTime,
    required this.id,
    required this.batch,
    required this.jobItem,
    required this.startTime,
    required this.updatedAt,
    required this.updatedBy,
    required this.weight,
    this.verified = false,
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      "id": id,
      "batch": batch,
      "job_item_id": jobItem,
      "weight": weight,
      "start_time": startTime,
      "end_time": endTime,
      "created_by": createdBy.toJSON(),
      "created_at": createdAt,
      "updated_by": updatedBy.toJSON(),
      "updated_at": updatedAt,
      "verified": verified,
    };
  }

  factory JobItemWeighing.fromJSON(Map<String, dynamic> jsonObject) {
    JobItemWeighing jobItemWeighing = JobItemWeighing(
      batch: jsonObject["batch"].toString(),
      createdAt: DateTime.parse(jsonObject["created_at"]),
      createdBy: User.fromJSON(jsonObject["created_by"]),
      endTime: DateTime.parse(jsonObject["end_time"]).toLocal(),
      id: jsonObject["id"],
      jobItem: JobItem.fromJSON(jsonObject["job_item"]),
      startTime: DateTime.parse(jsonObject["start_time"]).toLocal(),
      updatedAt: DateTime.parse(jsonObject["updated_at"]),
      updatedBy: User.fromJSON(jsonObject["updated_by"]),
      weight: double.parse(jsonObject["weight"].toString()),
      verified: jsonObject["verified"],
    );
    return jobItemWeighing;
  }
}
