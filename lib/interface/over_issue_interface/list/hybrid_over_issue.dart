import 'package:eazyweigh/application/app_store.dart';
import 'package:eazyweigh/domain/entity/job.dart';
import 'package:eazyweigh/domain/entity/over_issue.dart';

class HybridOverIssue {
  final OverIssue overIssue;
  final Job job;

  HybridOverIssue._({
    required this.job,
    required this.overIssue,
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      "over_issue": overIssue.toJSON(),
      "job": job.toJSON(),
    };
  }

  static Future<HybridOverIssue> fromServer(Map<String, dynamic> jsonObject) async {
    late HybridOverIssue hybridOverIssue;

    await appStore.jobApp.get(jsonObject["job_id"]).then((jobResponse) async {
      Job job = await Job.fromServer(jobResponse["payload"]);
      await appStore.overIssueApp.list(job.id).then((value) async {
        late OverIssue overIssued;
        for (var item in value["payload"]) {
          OverIssue overIssue = await OverIssue.fromServer(item);
          if (overIssue.id == jsonObject["over_issue_id"]) {
            overIssued = overIssue;
          }
        }
        hybridOverIssue = HybridOverIssue._(
          job: job,
          overIssue: overIssued,
        );
      });
    });

    return hybridOverIssue;
  }
}
