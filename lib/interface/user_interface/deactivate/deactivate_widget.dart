import 'package:eazyweigh/interface/common/build_widget.dart';
import 'package:eazyweigh/interface/common/super_widget/super_widget.dart';
import 'package:flutter/material.dart';

class UserDeactivateWidget extends StatefulWidget {
  const UserDeactivateWidget({Key? key}) : super(key: key);

  @override
  State<UserDeactivateWidget> createState() => _UserDeactivateWidgetState();
}

class _UserDeactivateWidgetState extends State<UserDeactivateWidget> {
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
