import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:flutter/material.dart';

class DeviceTypeDetailsWidget extends StatefulWidget {
  const DeviceTypeDetailsWidget({Key? key}) : super(key: key);

  @override
  State<DeviceTypeDetailsWidget> createState() => _DeviceTypeDetailsWidgetState();
}

class _DeviceTypeDetailsWidgetState extends State<DeviceTypeDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return SuperPage(
      childWidget: buildWidget(
        Container(),
        context,
        "Device Type Details",
        () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
