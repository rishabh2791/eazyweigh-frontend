import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/job.dart';
import 'package:eazyweigh/domain/entity/under_issue.dart';

class HybridUnderIssue {
  final UnderIssue underIssue;
  final Job job;

  HybridUnderIssue._({
    required this.job,
    required this.underIssue,
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      "under_issue": underIssue.toJSON(),
      "job": job.toJSON(),
    };
  }

  static Future<HybridUnderIssue> fromServer(Map<String, dynamic> jsonObject) async {
    late HybridUnderIssue hybridUnderIssue;

    await appStore.jobApp.get(jsonObject["job_id"]).then((jobResponse) async {
      Job job = await Job.fromServer(jobResponse["payload"]);
      await appStore.underIssueApp.list(job.id).then((value) async {
        late UnderIssue underIssued;
        for (var item in value["payload"]) {
          UnderIssue underIssue = await UnderIssue.fromServer(item);
          if (underIssue.id == jsonObject["over_issue_id"]) {
            underIssued = underIssue;
          }
        }
        hybridUnderIssue = HybridUnderIssue._(
          job: job,
          underIssue: underIssued,
        );
      });
    });

    return hybridUnderIssue;
  }
}
