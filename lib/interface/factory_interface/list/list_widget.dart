import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:flutter/material.dart';

class FactoryListWidget extends StatefulWidget {
  const FactoryListWidget({Key? key}) : super(key: key);

  @override
  State<FactoryListWidget> createState() => _FactoryListWidgetState();
}

class _FactoryListWidgetState extends State<FactoryListWidget> {
  @override
  Widget build(BuildContext context) {
    return SuperPage(childWidget: loader(context));
  }
}
