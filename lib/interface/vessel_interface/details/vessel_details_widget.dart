import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:flutter/material.dart';

class VesselDetailsWidget extends StatefulWidget {
  const VesselDetailsWidget({Key? key}) : super(key: key);

  @override
  State<VesselDetailsWidget> createState() => _VesselDetailsWidgetState();
}

class _VesselDetailsWidgetState extends State<VesselDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return SuperPage(
      childWidget: buildWidget(
        Container(),
        context,
        "Vessel Details",
        () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
