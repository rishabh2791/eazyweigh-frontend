import 'package:eazyweigh/domain/entity/job_item.dart';
import 'package:eazyweigh/domain/entity/over_issue.dart';
import 'package:flutter/material.dart';

class OverIssueItemDetailsWidget extends StatefulWidget {
  final OverIssue overIssue;
  final JobItem jobItem;
  const OverIssueItemDetailsWidget({
    Key? key,
    required this.jobItem,
    required this.overIssue,
  }) : super(key: key);

  @override
  State<OverIssueItemDetailsWidget> createState() =>
      _OverIssueItemDetailsWidgetState();
}

//TODO
class _OverIssueItemDetailsWidgetState
    extends State<OverIssueItemDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
