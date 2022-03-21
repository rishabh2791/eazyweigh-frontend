import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:eazyweigh/interface/common/ui_elements.dart';
import 'package:flutter/material.dart';

class UserRoleAccessWidget extends StatefulWidget {
  const UserRoleAccessWidget({Key? key}) : super(key: key);

  @override
  State<UserRoleAccessWidget> createState() => _UserRoleAccessWidgetState();
}

class _UserRoleAccessWidgetState extends State<UserRoleAccessWidget> {
  @override
  Widget build(BuildContext context) {
    return SuperPage(
      childWidget: loader(context),
    );
  }
}
