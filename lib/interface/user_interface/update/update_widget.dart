import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:flutter/material.dart';

class UserUpdateWidget extends StatefulWidget {
  const UserUpdateWidget({Key? key}) : super(key: key);

  @override
  State<UserUpdateWidget> createState() => _UserUpdateWidgetState();
}

class _UserUpdateWidgetState extends State<UserUpdateWidget> {
  //TODO complete this
  @override
  Widget build(BuildContext context) {
    return SuperPage(
      childWidget: buildWidget(
        Container(),
        context,
        "Get Materials List",
        () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
