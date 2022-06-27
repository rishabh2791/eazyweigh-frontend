import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:flutter/material.dart';

class JobAssignmentUpdateWidget extends StatefulWidget {
  const JobAssignmentUpdateWidget({Key? key}) : super(key: key);

  @override
  State<JobAssignmentUpdateWidget> createState() => _JobAssignmentUpdateWidgetState();
}

class _JobAssignmentUpdateWidgetState extends State<JobAssignmentUpdateWidget> {
  @override
  Widget build(BuildContext context) {
    return SuperPage(
      childWidget: buildWidget(
        Container(),
        context,
        "Get Materials List",
        () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
