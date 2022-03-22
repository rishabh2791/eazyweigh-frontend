import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:flutter/material.dart';

class FactoryCreateWidget extends StatefulWidget {
  const FactoryCreateWidget({Key? key}) : super(key: key);

  @override
  State<FactoryCreateWidget> createState() => _FactoryCreateWidgetState();
}

class _FactoryCreateWidgetState extends State<FactoryCreateWidget> {
  @override
  Widget build(BuildContext context) {
    return SuperPage(childWidget: loader(context));
  }
}
