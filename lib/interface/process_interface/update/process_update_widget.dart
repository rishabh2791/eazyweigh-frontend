import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:flutter/material.dart';

class ProcessUpdateWidget extends StatefulWidget {
  const ProcessUpdateWidget({Key? key}) : super(key: key);

  @override
  State<ProcessUpdateWidget> createState() => _ProcessUpdateWidgetState();
}

class _ProcessUpdateWidgetState extends State<ProcessUpdateWidget> {
  @override
  Widget build(BuildContext context) {
    return SuperPage(
      childWidget: buildWidget(
        Container(),
        context,
        "Update Process",
        () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
