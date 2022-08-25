import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:flutter/material.dart';

class StepTypeDetailsWidget extends StatefulWidget {
  const StepTypeDetailsWidget({Key? key}) : super(key: key);

  @override
  State<StepTypeDetailsWidget> createState() => _StepTypeDetailsWidgetState();
}

class _StepTypeDetailsWidgetState extends State<StepTypeDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return SuperPage(
      childWidget: buildWidget(
        Container(),
        context,
        "StepType Details",
        () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
