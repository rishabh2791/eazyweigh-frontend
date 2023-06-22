import 'package:eazyweigh/domain/entity/job.dart';
import 'package:eazyweigh/domain/entity/under_issue.dart';

class HybridUnderIssue {
  final UnderIssue underIssue;
  final Job job;

  HybridUnderIssue({
    required this.job,
    required this.underIssue,
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      "under_issue": underIssue.toJSON(),
      "job": job.toJSON(),
    };
  }

  factory HybridUnderIssue.fromJSON(Map<String, dynamic> jsonObject) {
    HybridUnderIssue hybridUnderIssue = HybridUnderIssue(
      job: Job.fromJSON(jsonObject["job"]),
      underIssue: UnderIssue.fromJSON(jsonObject["under_issue"]),
    );
    return hybridUnderIssue;
  }
}
