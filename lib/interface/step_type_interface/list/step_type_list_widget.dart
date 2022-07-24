import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:flutter/material.dart';

class StepTypeListWidget extends StatefulWidget {
  const StepTypeListWidget({Key? key}) : super(key: key);

  @override
  State<StepTypeListWidget> createState() => _StepTypeListWidgetState();
}

class _StepTypeListWidgetState extends State<StepTypeListWidget> {
  @override
  Widget build(BuildContext context) {
    return SuperPage(
      childWidget: buildWidget(
        Container(),
        context,
        "StepType List",
        () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
