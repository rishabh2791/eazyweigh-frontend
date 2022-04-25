import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:flutter/material.dart';

class TerminalUpdateWidget extends StatefulWidget {
  const TerminalUpdateWidget({Key? key}) : super(key: key);

  @override
  State<TerminalUpdateWidget> createState() => _TerminalUpdateWidgetState();
}

class _TerminalUpdateWidgetState extends State<TerminalUpdateWidget> {
  //TODO complete this
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
