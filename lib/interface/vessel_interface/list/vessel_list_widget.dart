import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:flutter/material.dart';

class VesselListWidget extends StatefulWidget {
  const VesselListWidget({Key? key}) : super(key: key);

  @override
  State<VesselListWidget> createState() => _VesselListWidgetState();
}

class _VesselListWidgetState extends State<VesselListWidget> {
  @override
  Widget build(BuildContext context) {
    return SuperPage(
      childWidget: buildWidget(
        Container(),
        context,
        "Vessels List",
        () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
