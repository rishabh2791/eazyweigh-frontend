import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:flutter/material.dart';

class StepTypeCreateWidget extends StatefulWidget {
  const StepTypeCreateWidget({Key? key}) : super(key: key);

  @override
  State<StepTypeCreateWidget> createState() => _StepTypeCreateWidgetState();
}

class _StepTypeCreateWidgetState extends State<StepTypeCreateWidget> {
  @override
  Widget build(BuildContext context) {
    return SuperPage(
      childWidget: buildWidget(
        Container(),
        context,
        "Create StepType",
        () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
