import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:flutter/material.dart';

class DeviceCreateWidget extends StatefulWidget {
  const DeviceCreateWidget({Key? key}) : super(key: key);

  @override
  State<DeviceCreateWidget> createState() => _DeviceCreateWidgetState();
}

class _DeviceCreateWidgetState extends State<DeviceCreateWidget> {
  @override
  Widget build(BuildContext context) {
    return SuperPage(
      childWidget: buildWidget(
        Container(),
        context,
        "Create Device",
        () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
