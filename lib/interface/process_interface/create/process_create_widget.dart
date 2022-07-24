import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:flutter/material.dart';

class ProcessCreateWidget extends StatefulWidget {
  const ProcessCreateWidget({Key? key}) : super(key: key);

  @override
  State<ProcessCreateWidget> createState() => _ProcessCreateWidgetState();
}

class _ProcessCreateWidgetState extends State<ProcessCreateWidget> {
  @override
  Widget build(BuildContext context) {
    return SuperPage(
      childWidget: buildWidget(
        Container(),
        context,
        "Create Process",
        () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
