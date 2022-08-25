import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:flutter/material.dart';

class ProcessDetailsWidget extends StatefulWidget {
  const ProcessDetailsWidget({Key? key}) : super(key: key);

  @override
  State<ProcessDetailsWidget> createState() => _ProcessDetailsWidgetState();
}

class _ProcessDetailsWidgetState extends State<ProcessDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return SuperPage(
      childWidget: buildWidget(
        Container(),
        context,
        "Process Details",
        () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
