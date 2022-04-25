import 'package:eazyweigh/domain/entity/job.dart';
import 'package:eazyweigh/domain/entity/over_issue.dart';

class HybridOverIssue {
  final OverIssue overIssue;
  final Job job;

  HybridOverIssue({
    required this.job,
    required this.overIssue,
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      "over_issue": overIssue.toJSON(),
      "job": job.toJSON(),
    };
  }

  factory HybridOverIssue.fromJSON(Map<String, dynamic> jsonObject) {
    HybridOverIssue hybridOverIssue = HybridOverIssue(
      job: Job.fromJSON(jsonObject["job"]),
      overIssue: OverIssue.fromJSON(jsonObject["over_issue"]),
    );
    return hybridOverIssue;
  }
}
