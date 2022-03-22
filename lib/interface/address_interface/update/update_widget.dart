import 'package:eazyweigh/interface/common/loader.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:flutter/material.dart';

class AddressUpdateWidget extends StatefulWidget {
  const AddressUpdateWidget({Key? key}) : super(key: key);

  @override
  State<AddressUpdateWidget> createState() => _AddressUpdateWidgetState();
}

class _AddressUpdateWidgetState extends State<AddressUpdateWidget> {
  @override
  Widget build(BuildContext context) {
    return SuperPage(childWidget: loader(context));
  }
}
