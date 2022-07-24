import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:flutter/material.dart';

class VesselCreateWidget extends StatefulWidget {
  const VesselCreateWidget({Key? key}) : super(key: key);

  @override
  State<VesselCreateWidget> createState() => _VesselCreateWidgetState();
}

class _VesselCreateWidgetState extends State<VesselCreateWidget> {
  @override
  Widget build(BuildContext context) {
    return SuperPage(
      childWidget: buildWidget(
        Container(),
        context,
        "Create Vessel",
        () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
