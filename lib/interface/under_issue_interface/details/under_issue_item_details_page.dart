import 'package:eazyweigh/domain/entity/job_item.dart';
import 'package:eazyweigh/domain/entity/under_issue.dart';
import 'package:flutter/material.dart';

class UnderIssueItemDetailsWidget extends StatefulWidget {
  final UnderIssue underIssue;
  final JobItem jobItem;
  const UnderIssueItemDetailsWidget({
    Key? key,
    required this.jobItem,
    required this.underIssue,
  }) : super(key: key);

  @override
  State<UnderIssueItemDetailsWidget> createState() =>
      _UnderIssueItemDetailsWidgetState();
}

//TODO
class _UnderIssueItemDetailsWidgetState
    extends State<UnderIssueItemDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
