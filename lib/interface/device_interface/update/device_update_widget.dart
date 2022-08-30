import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:flutter/material.dart';

class DeviceUpdateWidget extends StatefulWidget {
  const DeviceUpdateWidget({Key? key}) : super(key: key);

  @override
  State<DeviceUpdateWidget> createState() => _DeviceUpdateWidgetState();
}

class _DeviceUpdateWidgetState extends State<DeviceUpdateWidget> {
  @override
  Widget build(BuildContext context) {
    return SuperPage(
      childWidget: buildWidget(
        Container(),
        context,
        "Update Device",
        () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
