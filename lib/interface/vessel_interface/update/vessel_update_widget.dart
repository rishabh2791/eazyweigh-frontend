import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:flutter/material.dart';

class VesselUpdateWidget extends StatefulWidget {
  const VesselUpdateWidget({Key? key}) : super(key: key);

  @override
  State<VesselUpdateWidget> createState() => _VesselUpdateWidgetState();
}

class _VesselUpdateWidgetState extends State<VesselUpdateWidget> {
  @override
  Widget build(BuildContext context) {
    return SuperPage(
      childWidget: buildWidget(
        Container(),
        context,
        "Update Vessel",
        () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
