import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:flutter/material.dart';

class FactoryDetailsWidget extends StatefulWidget {
  const FactoryDetailsWidget({Key? key}) : super(key: key);

  @override
  State<FactoryDetailsWidget> createState() => _FactoryDetailsWidgetState();
}

class _FactoryDetailsWidgetState extends State<FactoryDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return SuperPage(childWidget: loader(context));
  }
}
