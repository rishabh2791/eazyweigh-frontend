import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:flutter/material.dart';

class ProcessListWidget extends StatefulWidget {
  const ProcessListWidget({Key? key}) : super(key: key);

  @override
  State<ProcessListWidget> createState() => _ProcessListWidgetState();
}

class _ProcessListWidgetState extends State<ProcessListWidget> {
  @override
  Widget build(BuildContext context) {
    return SuperPage(
      childWidget: buildWidget(
        Container(),
        context,
        "Process List",
        () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
