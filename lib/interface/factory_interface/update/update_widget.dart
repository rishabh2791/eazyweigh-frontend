import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:flutter/material.dart';

class FactoryUpdateWidget extends StatefulWidget {
  const FactoryUpdateWidget({Key? key}) : super(key: key);

  @override
  State<FactoryUpdateWidget> createState() => _FactoryUpdateWidgetState();
}

class _FactoryUpdateWidgetState extends State<FactoryUpdateWidget> {
  @override
  Widget build(BuildContext context) {
    return SuperPage(childWidget: loader(context));
  }
}
