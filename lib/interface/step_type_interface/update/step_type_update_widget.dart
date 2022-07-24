import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:flutter/material.dart';

class StepTypeUpdateWidget extends StatefulWidget {
  const StepTypeUpdateWidget({Key? key}) : super(key: key);

  @override
  State<StepTypeUpdateWidget> createState() => _StepTypeUpdateWidgetState();
}

class _StepTypeUpdateWidgetState extends State<StepTypeUpdateWidget> {
  @override
  Widget build(BuildContext context) {
    return SuperPage(
      childWidget: buildWidget(
        Container(),
        context,
        "Update StepType",
        () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
