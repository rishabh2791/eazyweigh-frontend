import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:flutter/material.dart';

class UOMListWidget extends StatefulWidget {
  const UOMListWidget({Key? key}) : super(key: key);

  @override
  State<UOMListWidget> createState() => _UOMListWidgetState();
}

class _UOMListWidgetState extends State<UOMListWidget> {
  //TODO complete this
  @override
  Widget build(BuildContext context) {
    return SuperPage(
      childWidget: buildWidget(
        Container(),
        context,
        "Get UOM List",
        () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
