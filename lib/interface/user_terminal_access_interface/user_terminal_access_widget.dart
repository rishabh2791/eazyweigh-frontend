import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/ui_elements.dart';
import 'package:flutter/material.dart';

class UserTerminalAccessWidget extends StatefulWidget {
  const UserTerminalAccessWidget({Key? key}) : super(key: key);

  @override
  State<UserTerminalAccessWidget> createState() =>
      _UserTerminalAccessWidgetState();
}

class _UserTerminalAccessWidgetState extends State<UserTerminalAccessWidget> {
  @override
  Widget build(BuildContext context) {
    return SuperPage(
      childWidget: loader(context),
    );
  }
}
