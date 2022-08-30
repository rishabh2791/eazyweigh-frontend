import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:flutter/material.dart';

class DeviceDataListWidget extends StatefulWidget {
  const DeviceDataListWidget({Key? key}) : super(key: key);

  @override
  State<DeviceDataListWidget> createState() => _DeviceDataListWidgetState();
}

class _DeviceDataListWidgetState extends State<DeviceDataListWidget> {
  @override
  Widget build(BuildContext context) {
    return SuperPage(
      childWidget: buildWidget(
        Container(),
        context,
        "Device Data",
        () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
